#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Element

    @@data = nil
    attr_reader :name

    def initialize(args_hash = {})
      @room = Room[args_hash[:room]]
      @room.register_element self, @name = args_hash[:name]
      set_state self.state || :off
    end

    def state
      @@data[@room.name, @name] if @@data
    end

    def verbose_state
      { @room.name =>
        { :elements =>
          { @name =>
            { :state => state,
              :info => (info if respond_to? :info)
            }
          }
        }
      }
    end

    def set_state(value)
      @@data[@room.name, @name] = value if @@data
      @room.notify [:state_set, self]
      value
    end

    def on_state_changed(value)
      @@data[@room.name, @name] = value if @@data
      @room.notify [:state_changed, self]
      value
    end

    def self.data=(value)
      @@data = value
    end

  end
end