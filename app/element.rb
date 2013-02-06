#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Element
    def initialize(args_hash = {})
      @room = args_hash[Room[:room]]
      @room.register_element self, args_hash[:name]
      @state = :off
      super
    end
    def state
      @state
    end
    def on_state_changed(pin_state)
      @state = to_logical pin_state
      @room.push_event self.dup
    end
  end
end