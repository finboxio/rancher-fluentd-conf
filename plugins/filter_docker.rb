require 'fluent/filter'

module Fluent
  class DockerFilter < Filter

    Plugin.register_filter('docker', self)

    config_param :container_id, :string
    config_param :docker_containers_path, :string, :default => '/var/lib/docker/containers'

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
      # This method implements the filtering logic for individual filters
      id = interpolate(tag, @container_id)
      config = get_cfg(id)

      record['container_id'] = id
      record['container_name'] = config['Name'] || '<unknown>'

      unless config['Config']['Labels'].nil?
        config['Config']['Labels'].each_pair do |k,v|
          record[k] = v.to_s
        end
      end
      record
    end

    private

    def interpolate(tag, str)
      tag_parts = tag.split('.')
      str.gsub(/\$\{tag_parts\[(\d+)\]\}/) { |m| tag_parts[$1.to_i] }
    end

    def get_name(id)
      @id_to_cfg[id] = get_cfg(id) unless @id_to_cfg.has_key? id
      @id_to_cfg[id]['Name']
    end

    def get_cfg(id)
      begin
        config_path = "#{@docker_containers_path}/#{id}/config.json"
        if not File.exists?(config_path)
          config_path = "#{@docker_containers_path}/#{id}/config.v2.json"
        end
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
