#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class ArduinoBoard < Device
    include Arduino::ArduinoSerial

    def initialize(args_hash = {})
      @pins = Hash.new
      super
    end
    
    # Register pin for watch events
    def register_pin(pin_object, number)
      @pins[number] = pin_object
    end
    
    # Return pin object
    def [](number = nil)
      return @pins[number] if number
      @pins
    end

    private
    
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
  end
end