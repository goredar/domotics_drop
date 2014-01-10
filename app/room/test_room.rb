module Domotics
  class TestRoom < Room
    def initialize(args = {})
      super
      @events = {}
    end
    def event_handler(msg = {})
      event, element = msg[:event], msg[:element]
      if element
        @events[element.name] ||= []
        @events[element.name].push event => element.state
      end
      super
    end
    def last_event(element_name)
      @events[element_name].pop if @events[element_name].respond_to? :pop
    end
  end
end