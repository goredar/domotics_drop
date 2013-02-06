#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Element
    def initialize(args_hash = {})
      @room = args_hash[Room[:room]]
      @room.register_element self, args_hash[:name]
      @state = :off
    end
    def state
      @state
    end
    def state=(value)
      # Set hardware state
      super to_digital(value)
      # And save it
      @state = value
    end
    def on_state_changed(pin_state)
      @state = to_logical pin_state
      @room.push_event self.dup
    end
  end
end