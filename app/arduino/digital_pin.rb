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
    def hardware_state
      to_logical @board.get_digital @pin
    end
    def state=(value)
      @board.set_digital @pin, to_digital value
    end
    #  Override in children for needed action
    def on_state_changed(pin_state)
      # Dummy
      p pin_state
    end
    #  Override in children if other states
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