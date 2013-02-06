#!/usr/bin/ruby -w
# coding: utf-8

module Arduino

  class ArduinoBoard < ArduinoSerial
    @@boards = {}

    def initialize(args_hash = {})
      p args_hash
      # Array of pins objects
      @pins = []
      @@boards[args_hash[:name]] = self
      super
    end
    # Register pin for watch events
    def register_pin(pin_object, number)
      @pins[number] = pin_object
    end
    # Return pin object
    def [](number)
      @pins[number]
    end
    # Override default handler
    def event_handler(hash)
      case hash[:event]
      # Tell element to change state
      when :pinstate
        @pins[hash[:pin]].on_state_changed hash[:state]
      when :boardreset
        nil
      else
        nil
      end
    end

    def self.[](symbol)
      @@boards[symbol]
    end
  end
end
