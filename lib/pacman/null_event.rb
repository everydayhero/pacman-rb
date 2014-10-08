module Pacman
  class NullEvent < Event
    def valid?
      false
    end
  end
end
