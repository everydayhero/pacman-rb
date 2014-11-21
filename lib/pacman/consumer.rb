require 'logger'
require 'kcl'
require 'configify'

module Pacman
  class Consumer
    include Configify

    configuration do
      env_variable_prefix 'EVENT_QUEUE'

      property :topic
      property :consumer_name
      property :max_records, default: 10
      property :reads_interval, default: 1000
    end

    attr_reader :config, :logger

    def initialize config: config, logger: Logger.new(STDOUT)
      @config = config
      @logger = logger
    end

    def consume &block
      logger.info 'start consuming events'

      consumer_executor.record_processor do
        EventProcessor.new block
      end

      consumer_executor.run
    end

    private

    def consumer_executor
      @consumer_executor ||= Kcl::Executor.new do |executor|
        executor.config stream_name: config.topic,
                        application_name: config.consumer_name,
                        max_records: config.max_records,
                        idle_time_between_reads_in_millis: config.reads_interval
      end
    end
  end
end
