module Pacman
  class Event
    attr_reader :name, :time, :payload, :message_id

    def initialize name: nil, time: nil, payload: nil, message_id: nil
      @name = name
      @time = time
      @payload = payload
      @message_id = message_id
    end

    def to_event_hash
      {
        name: name,
        time: time,
        payload: payload,
        message_id: message_id
      }
    end

    def to_json
      to_event_hash.to_json
    end
  end
end
