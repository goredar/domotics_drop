#!/usr/bin/ruby -w
# coding: utf-8

require 'open-uri'

module Domotics
  class Element
    attr_reader :name
    def initialize(args_hash = {})
      @room = Room[args_hash[:room]]
      @room.register_element self, @name = args_hash[:name]
      if args_hash[:state]
        set_state args_hash[:state]
      else
        @state = :off
      end
    end
    def state
      @state
    end
    def set_state(value)
      @state = value
    end
    def on_state_changed(state)
      @state = state
      @room.notify self.dup
    end
  end
end