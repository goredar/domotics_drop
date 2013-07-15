#!/usr/bin/ruby -w
# coding: utf-8

module Arduino
  module PWMPin
    include DigitalPin
    def set_level(value = 0)
      value = value.to_i
      case value
      when 0..7
        @board.set_low @pin
      when 8..247
        @board.set_pwm @pin, value
      when 248-255
        @board.set_high @pin
      end
    end
  end
end