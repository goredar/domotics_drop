#!/usr/bin/ruby -w
# coding: utf-8

# Digital pin
module Arduino
  module DigitalPin
    def initialize(args_hash = {})
      super
      @board, @pin = DuinoBoard[args_hash[:board]], args_hash[:pin]
      @board.register_pin self, @pin
    end
    
    def state!
      to_logical @board.get_digital @pin
    end
    def set_state(value)
      @board.set_digital @pin, to_digital(value)
    end
    
    def on_state_changed(pin_state)
      p pin_state
    end
    
    def to_logical(value)
      value == ArduinoSerial::LOW ? :off : :on
    end
    def to_digital(value)
      case value
      when ArduinoSerial::LOW, ArduinoSerial::HIGH
        value
      when :off
        ArduinoSerial::LOW
      when :on
        ArduinoSerial::HIGH
      end
    end
  rescue ArgumentError => e
    $stderr.puts e.message
    nil
  end
end
