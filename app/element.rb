#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Element
    attr_reader :name
    def initialize(args_hash = {})
      @room = Room[args_hash[:room]]
      @room.register_element self, @name = args_hash[:name]
      set_state self.state || :off
    end
    def state
      @@data[@room.name, @name]
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
      @@data[@room.name, @name] = value
      $logger.info { "#{@room.name}::#{@name} set state to #{value}" }
      value
    end
    def on_state_changed(value)
      @@data[@room.name, @name] = value
      @room.notify self
      $logger.info { "#{@room.name}::#{@name} state changed to #{value}" }
      value
    end

    def self.data=(value)
      @@data = value
    end
  end
end