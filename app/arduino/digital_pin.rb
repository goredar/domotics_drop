#!/usr/bin/ruby -w
# coding: utf-8

# Digital pin
module Arduino
  module DigitalPin
    def initialize(args_hash = {})
      super
      @board = ArduinoBoard[args_hash[:device]]
      @pin = args_hash[:pin]
      @board.register_pin self, @pin
    end
    def state!
      to_hls @board.get_digital(@pin)
    end
    def state=(value)
      @board.set_digital @pin, to_lls(value)
      super
    end
    #  Override in child for needed action
    def on_state_changed(pin_state)
      # Dummy
    end
    # Override in children if other states
    # Convert to High Level State
    def to_hls(value)
      value == ArduinoSerial::HIGH ? :on : :off
    end
    # Convert to Low Level State
    def to_lls(value)
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
