require 'kcl'
require 'configify'

module Pacman
  class Consumer
    include Configify

    configuration do
      env_variable_prefix 'EVENT_QUEUE'

      property :topic
      property :consumer_name
      property :worker_id,
               default: "#{ENV.fetch('HOSTNAME', `hostname`).strip}-#{Time.now.to_i}"
      property :max_records, default: 10
      property :reads_interval, default: 1000
      property :initial_position, default: 'TRIM_HORIZON'
      property :max_active_threads, default: 0
      property :shard_sync_interval, default: 60_000
    end

    attr_reader :config

    def initialize config: config
      @config = config
    end

    def consume &block
      consumer_executor.record_processor do
        EventProcessor.new config.consumer_name, block
      end

      consumer_executor.run ARGV
    end

    private

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def consumer_executor
      @consumer_executor ||= Kcl::Executor.new do |executor|
        executor.config stream_name: config.topic,
                        worker_id: config.worker_id,
                        application_name: config.consumer_name,
                        max_records: config.max_records,
                        initial_position_in_stream: config.initial_position,
                        max_active_threads: config.max_active_threads,
                        shard_sync_interval_millis: config.shard_sync_interval,
                        idle_time_between_reads_in_millis: config.reads_interval

        executor.extra_class_path(*jar_files)

        executor.system_properties 'log4j.configuration' => log4j_config
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

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
