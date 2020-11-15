require 'fluent/filter'

module Fluent
  class ExpatFilter < Filter

    Plugin.register_filter('expat', self)

    config_param :log_key, :string, :default => 'log'
    config_param :pattern_key, :string, :default => 'docker.container.labels.fluentd.pattern'
    config_param :exlude_key, :string, :default => 'docker.container.labels.fluentd.ignore'
    config_param :time_key, :string, :default => 'docker.container.labels.fluentd.timestamp'

    def initialize
      super
      require 'json'
    end

    def configure(conf)
      super
    end

    def start
      super
    end

    def shutdown
      super
    end

    def filter(tag, time, record)
      log = record[@log_key]
      unless record[@pattern_key].nil?
        if record[@pattern_key] then
          begin
            pattern = Regexp.new record[@pattern_key]
            parse_pattern(pattern, uncolorize(log), record)
          rescue => exception
            puts exception
          end
        end
      end

      unless record[@time_key].nil?
        begin
          parts = record[@time_key].split('.')
          timestamp = parts.inject(record) { |record, part| record[part] }
          dt = DateTime.parse(timestamp).to_time.utc

          # update actual record time
          record['actual_unix_timestamp'] = dt.to_i

          # update timestamp for kibana
          record['@timestamp'] = dt.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
        rescue => exception
          puts exception
        end
      end

      unless !record[@exlude_key].nil?
        record
      end
    end

    private

    def parse_pattern(pattern, msg, record)
      match = pattern.match(msg)
      if not match.nil? then
        record['expat'] = {}
        match.names.each do |name|
          begin
            if name == 'ecs.message' then
              record['log.original'] = record['message']
              record['message'] = match['ecs.message']
            elsif name.start_with? 'ecs.' then
              record[name[4..-1]] = match[name]
            # .json matches will be parsed into metadata assuming json format
            elsif name.end_with? '.json' then
              entries = JSON.parse(match[name])
              entries.delete_if do | field, value |
                if field.start_with? 'ecs.' then
                  # TODO: do we need to coerce these values?
                  record[field[4..-1]] = value
                  return true
                end
              end

              field = name[0..-6]
              record['expat'].merge!(to_flat_hash({ field => entries }))
            elsif name.end_with? '.num' then
              record['expat'][name[0..-5]] = match[name].to_f
            else
              record['expat'][name] = match[name]
            end
          rescue => exception
            puts exception
            record['expat'][name] = match[name]
          end
        end
      end
      record
    end

    def parse_json(string)
      JSON.parse(string)
    end

    def to_flat_hash(hash, recursive_key = "")
      hash.each_with_object({}) do |(k, v), ret|
        key = recursive_key + k.to_s
        if v.is_a? Hash then
          ret.merge! to_flat_hash(v, key + "_")
        else
          ret[key] = v
        end
      end
    end

    def uncolorize(string)
      string.gsub(/\033\[\d{1,2}(;\d{1,2}){0,2}[mGK]/, '')
    end
  end
end
