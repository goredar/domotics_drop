#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Element
    def initialize(args_hash = {})
      @room = Room[args_hash[:room]]
      @room.register_element self, args_hash[:name]
      @state = :off
    end
    def state
      @state
    end
    def state=(value)
      # Set hardware state and save it
      @state = value if super
    end
    def on_state_changed(pin_state)
      @state = to_hls pin_state
      @room.push_event self.dup
    end
  end
end