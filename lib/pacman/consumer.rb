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
      property :initial_position, default: 'TRIM_HORIZON'
    end

    attr_reader :config, :logger

    def initialize config: config
      @config = config
      @logger = logger
    end

    def consume &block
      consumer_executor.record_processor do
        EventProcessor.new block
      end

      consumer_executor.run ARGV
    end

    private

    def consumer_executor
      @consumer_executor ||= Kcl::Executor.new do |executor|
        executor.config stream_name: config.topic,
                        application_name: config.consumer_name,
                        max_records: config.max_records,
                        initial_position_in_stream: config.initial_position,
                        idle_time_between_reads_in_millis: config.reads_interval

        executor.extra_class_path(*jar_files)

        executor.system_properties 'log4j.configuration' => log4j_config
      end
    end

    def log4j_config
      @log4j_config ||= "file:#{jar_dir}/log4j.properties"
    end

    def jar_files
      @jar_files ||= Dir["#{jar_dir}/*.jar"]
    end

    def jar_dir
      @jar_dir ||= File.expand_path '../../jars', __FILE__
    end
  end
end
