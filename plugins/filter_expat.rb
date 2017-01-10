require 'fluent/filter'

module Fluent
  class ExpatFilter < Filter

    Plugin.register_filter('expat', self)

    config_param :log_key, :string, :default => 'log'
    config_param :pattern_key, :string, :default => 'fluentd.pattern'
    config_param :exlude_key, :string, :default => 'fluentd.ignore'

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
      unless !record[@exlude_key].nil?
        record
      end
    end

    private

    def parse_pattern(pattern, msg, record)
      match = pattern.match(msg)
      if not match.nil? then
        match.names.each do |name|
          begin
            # .json matches will be parsed into metadata assuming json format
            if name.end_with? '.json' then
              entries = parse_json(name[0..-6], match[name])
              record.merge! entries
            elsif name.end_with? '.num' then
              record[name[0..-5]] = match[name].to_f
            else
              record[name] = match[name]
            end
          rescue => exception
            puts exception
            record[name] = match[name]
          end
        end
      end
      record
    end

    def parse_json(ns, string)
      record = {}
      if ns == "_" then
        record = JSON.parse(string)
      else
        record[ns] = JSON.parse(string)
      end
      to_dotted_hash(record)
    end

    def to_dotted_hash(hash, recursive_key = "")
      hash.each_with_object({}) do |(k, v), ret|
        key = recursive_key + k.to_s
        if v.is_a? Hash then
          ret.merge! to_dotted_hash(v, key + ".")
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
