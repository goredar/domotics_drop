#!/usr/bin/ruby -w
# coding: utf-8

require 'open-uri'

module Domotics
  class Element
    def initialize(args_hash = {})
      @room = Room[args_hash[:room]]
      @room.register_element self, args_hash[:name]
      if args_hash[:state]
        self.state=(args_hash[:state].to_sym)
      else
        @state = :off
      end
    end
    def state
      @state
    end
    def state=(value)
      @state = value
    end
    def on_state_changed(state)
      @state = state
      @room.notify self.dup
    end
  end
end