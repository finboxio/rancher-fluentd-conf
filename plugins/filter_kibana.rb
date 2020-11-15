require 'fluent/plugin/filter'

module Fluent::Plugin
  class KibanaFilter < Filter
    Fluent::Plugin.register_filter('kibana', self)

    config_param :hostname, :string, default: '<unknown>'
    config_param :group, :string, default: ''
    config_param :provider, :string, default: ''
    config_param :region, :string, default: ''
    config_param :az, :string, default: ''
    config_param :machine, :string, default: ''

    def filter(tag, time, record)
      record['host.name'] = @hostname
      record['host.group'] = @group
      record['cloud.provider'] = @provider
      record['cloud.region'] = @region
      record['cloud.availability_zone'] = @az
      record['cloud.machine.type'] = @machine

      record['@timestamp'] = Time.at(time.to_r).utc.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
      record['message'] = record['log']
      record.delete('log')

      record
    end
  end
end
