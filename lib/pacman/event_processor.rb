require 'kcl'

module Pacman
  class EventProcessor < Kcl::AdvancedRecordProcessor
    def initialize event_handler
      super()
      @event_handler = event_handler
    end

    def process_record record
      events = MessageEvent.from_messages [record]

      event_handler.call events if events.any?
    end

    private

    attr_reader :event_handler
  end
end
