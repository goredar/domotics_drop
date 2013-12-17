#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Element

    @@data = nil
    attr_reader :name, :room

    def initialize(args = {})
      @room = Room[args[:room]]
      @room.register_element self, @name = args[:name]
      set_state(self.state || :off)
    end

    def state
      @@data[self].state if @@data
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
      @@data[self].state = value if @@data
      @room.notify [:state_set, self]
      value
    end

    def on_state_changed(value)
      @@data[self].state = value if @@data
      @room.notify [:state_changed, self]
      value
    end

    def self.data=(value)
      @@data = value
    end

  end
end