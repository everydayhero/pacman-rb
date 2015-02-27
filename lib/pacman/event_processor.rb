require 'kcl'

module Pacman
  class EventProcessor < Kcl::AdvancedRecordProcessor
    def initialize consumer_name, event_handler
      super()
      @event_handler = event_handler
      @health_check_tracker = HealthCheckTracker.new consumer_name
    end

    def process_record record
      events = MessageEvent.from_messages [record]
      debug events
      health_check_track events

      event_handler.call events if events.any?
    end

    private

    attr_reader :event_handler, :health_check_tracker

    def debug events
      return unless ENV['PACMAN_DEBUG_EVENTS'] == 'true'

      events.each { |event| STDERR.puts event.to_json }
    end

    def health_check_track events
      events.each { |event| health_check_tracker.track event }
    end
  end
end
