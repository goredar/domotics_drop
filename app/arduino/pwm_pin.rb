#!/usr/bin/ruby -w
# coding: utf-8

module Arduino
  module PWMPin
    def initialize(args_hash = {})
      @board = Domotics::Device[args_hash[:device]]
      @pin = args_hash[:pin]
      super
    end
    def set_state(value = 0)
      value = case value
      when 0..7, :off
        @board.set_low @pin
        0
      when 8..249
        @board.set_pwm @pin, value
        value
      when 248..255, :on
        @board.set_high @pin
        255
      end
      super value
    end
  end
end