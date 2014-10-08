require 'pacman/message_event'
require 'logger'
require 'poseidon_cluster'
require 'configify'

module Pacman
  class Consumer
    include Configify

    configuration do
      env_variable_prefix 'EVENT_QUEUE'

      property :topic, default: 'events'
      property :consumer_name, default: 'pacman'
      property :hosts, default: 'localhost:9092'
      property :zookeeper_hosts, default: 'localhost:2181'

      def hosts
        @hosts.split ','
      end

      def zookeeper_hosts
        @zookeeper_hosts.split ','
      end
    end

    attr_reader :config, :logger

    def initialize config: config, logger: Logger.new(STDOUT)
      @config = config
      @logger = logger
    end

    def consume
      logger.info 'start consuming events'

      base_consumer.fetch_loop do |partition, messages|
        logger.debug "#{messages.count} messages fetched" if messages.any?
        events = MessageEvent.from_messages messages

        if events.any?
          logger.debug "#{events.count} events fetched"
          yield events
        end
      end
    end

    private

    def base_consumer
      @base_consumer ||= Poseidon::ConsumerGroup.new config.consumer_name,
        config.hosts,
        config.zookeeper_hosts,
        config.topic
    end
  end
end
