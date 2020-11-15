require 'fluent/filter'

module Fluent
  class DockerFilter < Filter

    Plugin.register_filter('docker', self)

    config_param :container_id, :string
    config_param :docker_containers_path, :string, :default => '/var/lib/docker/containers'
    config_param :targets_label, :string, :default => 'docker.container.labels.io.rancher.stack_service.name'

    def initialize
      super
      require 'json'
    end

    def configure(conf)
      super
      @id_to_cfg = {}
    end

    def start
      super
    end

    def shutdown
      super
    end

    def filter(tag, time, record)
      id = interpolate(tag, @container_id)
      config = get_cached_cfg(id)

      record['log'] = sanitize(record['log'])
      record['docker.container.id'] = id
      record['docker.container.name'] = config['Name'] || '<unknown>'

      unless config['Config']['Labels'].nil?
        config['Config']['Labels'].each_pair do |k,v|
          record['docker.container.labels.' + k] = v.to_s
        end
      end

      if record['docker.container.labels.fluentd.targets'].nil?
        record['docker.container.labels.fluentd.targets'] = record[@targets_label]
      end

      if ! record['docker.container.labels.fluentd.pattern'].nil?
        record
      end
    end

    private

    def interpolate(tag, str)
      tag_parts = tag.split('.')
      str.gsub(/\$\{tag_parts\[(\d+)\]\}/) { |m| tag_parts[$1.to_i] }
    end

    def get_cached_cfg(id)
      @id_to_cfg.clear if @id_to_cfg.length > 100
      @id_to_cfg[id] = get_cfg(id) unless @id_to_cfg.has_key? id
      @id_to_cfg[id]
    end

    def sanitize(string)
      string.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '-')
    end

    def get_cfg(id)
      begin
        config_path = "#{@docker_containers_path}/#{id}/config.v2.json"
        docker_cfg = JSON.parse(File.read(config_path))
        docker_cfg['Name'] = docker_cfg['Name'][1..-1]
      rescue => exception
        puts exception
        docker_cfg = {}
      end
      docker_cfg
    end
  end
end
