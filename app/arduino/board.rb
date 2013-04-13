#!/usr/bin/ruby -w
# coding: utf-8

module Arduino

  class ArduinoBoard < ArduinoSerial
    @@boards = {}

    def initialize(args_hash = {})
      # Array of pins objects
      @pins = []
      @name = args_hash[:name]
      @@boards[@name] = self
      super
    end
    def reload(saved_pins)
      @pins = saved_pins
    end
    # Register pin for watch events
    def register_pin(pin_object, number)
      @pins[number] = pin_object
    end
    # Return pin object
    def [](number = nil)
      if number
        @pins[number]
      else
        @pins
      end
    end
    # Override default handler
    def event_handler(hash)
      case hash[:event]
      # Tell element to change state
      when :pinstate
        @pins[hash[:pin]].on_state_changed hash[:state]
      when :malfunction
        nil
      else
        nil
      end
    end
    def destroy
      super
      @@boards[@name] = nil
    end
    
    def self.[](symbol = nil)
      if symbol
        @@boards[symbol]
      else
        @@boards
      end
    end
  end
end