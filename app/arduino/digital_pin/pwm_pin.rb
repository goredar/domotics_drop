#!/usr/bin/ruby -w
# coding: utf-8

module Arduino
  module PWMPin
    include DigitalPin
    def level=(value = 127)
      case value
      when 0
        @board.set_low @pin
      when 1..99
        @board.set_pwm @pin, value*255/100
      when 100
        @board.set_high @pin
      when 101..254
        @board.set_pwm @pin, value
      when 255
        @board.set_high @pin
      else
        raise ArgumentError, 'Invalid scale for PWM.'
      end
    end
  end
end