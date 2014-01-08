module Domotics
  class TestRoom < Room
    attr_reader :last_event
    def event_handler(msg)
      @last_event = msg
      super
    end
  end
end