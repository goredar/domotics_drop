#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Element
    def initialize(device, room, args_hash = {})
      @parent = Room[room]
      @parent.register_element self, args_hash[:name]
      @state = :off
      @hardware = nil
    end
    def state
      @state
    end
    def on_event(event_hash = {})
      case event_hash[:event]
      when :state_changed
        @state = convert_state value
        @room.event_push self.dup
      else
        nil
      end
    end
    def convert_state(value)
      value
    end
  end
end