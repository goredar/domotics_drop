#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Dimmer < Element
    include Arduino::PWMPin
    GRADATION_NUMBER = 16
    DEFAULT_LEVEL = 0
    MIN_LEVEL = 0
    MAX_LEVEL = 255
    def set_state(value = DEFAULT_LEVEL)
      if value.is_a? Integer
        value = 0 if (value < 0)
        value = 255 if value > 255
      end
      super value
    end
    # Decrease brightness level (value 0-100%)
    def dim(value = nil)
      if value
        set_state value*256/100
      else
        set_state state-256/GRADATION_NUMBER
      end
    end
    # Increase brightness level (value 0-100%)
    def bright(value = nil)
      if value
        set_state value*256/100
      else
        set_state  state+256/GRADATION_NUMBER
      end
    end
    def fade_in(sec = 4)
      Thread.new do
        set_state MIN_LEVEL
        GRADATION_NUMBER.times do
          bright
          sleep(sec/GRADATION_NUMBER)
        end
      end
    end
    def fade_out(sec = 4)
      Thread.new do
        set_state MAX_LEVEL
        GRADATION_NUMBER.times do
          dim
          sleep(sec/GRADATION_NUMBER)
        end
      end
    end
  end
end