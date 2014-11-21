require 'kcl'

module Pacman
  class EventProcessor < Kcl::AdvancedRecordProcessor
    def initialize event_handler
      @event_handler = event_handler
    end

    def process_record record
      events = MessageEvent.from_messages Array.wrap record

      event_handler.call events if events.any?
    end

    private

    attr_reader :event_handler
  end
end
