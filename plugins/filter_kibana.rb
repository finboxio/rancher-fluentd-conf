require 'fluent/plugin/filter'

module Fluent::Plugin
  class KibanaFilter < Filter
    Fluent::Plugin.register_filter('kibana', self)

    config_param :hostname, :string, default: '<unknown>'

    def filter(tag, time, record)
      record['@timestamp'] = Time.at(time.to_r).utc.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
      record['host.name'] = @hostname
      record['message'] = record['log']
      record.delete('log')
      record
    end
  end
end
