require 'fluent/filter'

module Fluent
  class ExpatFilter < Filter
    Plugin.register_filter('kibana', self)

    config_param :hostname, :string, default: '<unknown>'

    def initialize
      super
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
      record['@timestamp'] = Time.at(time.to_r).utc.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
      record['host.name'] = @hostname
      record
    end
  end
end
