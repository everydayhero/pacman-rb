module Pacman
  class MessageEvent < Event
    def valid?
      name && time
    end

    def self.from_messages raw_messages
      raw_messages.each_with_object Array.new do |message, array|
        event = from_message message
        array << event if event.valid?
      end
    end

    def self.from_message raw_message
      message_json = JSON.parse raw_message.value
      new name: message_json['name'],
          time: message_json['time'],
          message_id: raw_message.offset,
          payload: message_json['payload']
    rescue JSON::ParserError
      NullEvent.new
    end
  end
end
