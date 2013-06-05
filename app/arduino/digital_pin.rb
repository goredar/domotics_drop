#!/usr/bin/ruby -w
# coding: utf-8

# Digital pin
module Arduino
  module DigitalPin
    def initialize(args_hash = {})
      @board = Domotics::Device[args_hash[:device]]
      @pin = args_hash[:pin]
      @board.register_pin self, @pin
      super
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
      super to_hls(pin_state)
    end

    private

    # Convert to High Level State
    def to_hls(value)
      value == ArduinoSerial::HIGH ? :on : :off
    end
    # Convert to Low Level State
    def to_lls(value)
      value == :on ? ArduinoSerial::HIGH : ArduinoSerial::LOW
    end
  end
end