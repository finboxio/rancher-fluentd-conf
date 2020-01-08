require 'fluent/output'

module Fluent
  class FanoutPlugin < Output
    Plugin.register_output('fanout', self)

    desc 'Record field that identifies fanout targets'
    config_param :targets_key, :string, :default => nil

    def initialize
      super
    end

    def start
      super
    end

    def shutdown
      super
    end

    def configure(conf)
      super
    end

    def emit(tag, es, chain)
      es.each do |time,record|
        labels = []

        # skip global if private
        next if record['docker.container.labels.fluentd.private']
        labels.push('GLOBAL')

        # handle arrays, csv or space-separated strings
        if !@targets_key.nil? and !record[@targets_key].nil? and record[@targets_key].kind_of?(Array)
          labels += record[@targets_key]
        elsif !@targets_key.nil? and !record[@targets_key].nil? and record[@targets_key]
          labels += record[@targets_key].split(",").join(" ").split(" ")
        end

        # clean up the labels
        labels.compact.collect(&:strip)

        # re-emit the record to each specified label
        labels.uniq.each do |label|
          begin
            dest = Engine.root_agent.find_label("@" + label)
            dest.event_router.emit(tag, time, record)
          rescue => exception
            puts exception
          end
        end
      end

      chain.next
    end
  end
end
