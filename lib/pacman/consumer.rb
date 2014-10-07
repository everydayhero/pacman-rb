require 'logger'

module Pacman
  class Consumer
    include Configify

    configuration do
      env_variable_prefix 'EVENT_QUEUE'

      property :consumer_name, default: 'pacman'
      property :topic, default: 'events'
      property :url, default: 'localhost:9092'
    end

    attr_reder :config, :logger

    def initialize config: config, logger: Logger.new(STDOUT)
      @config = config
      @logger = logger
    end

    def consume
      logger.info 'start consuming events'
      loop do
        messages = base_consumer.fetch
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
      @base_consumer ||= Poseidon::PartitionConsumer.new config.consumer_name,
        config.host,
        config.port,
        config.topic,
        0,
        :latest_offset
    end
  end
end
