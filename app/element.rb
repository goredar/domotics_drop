#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Element
    attr_reader :name
    def initialize(args_hash = {})
      @room = Room[args_hash[:room]]
      @room.register_element self, @name = args_hash[:name]
      set_state state || :off
    end
    def state
      @@data[@room.name, @name]
    end
    def set_state(value)
      @@data[@room.name, @name] = value
    end
    def on_state_changed(value)
      @@data[@room.name, @name] = value
      @room.notify self
    end
    
    def self.data=(value)
      @@data = value
    end
  end
end