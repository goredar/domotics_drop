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
        value = MIN_LEVEL if value < MIN_LEVEL
        value = MAX_LEVEL if value > MAX_LEVEL
      end
      #puts '1' if state == value
      super value
    end
    # Decrease brightness level (value 0-100%)
    def dim(value = nil)
      if value
        set_state value * MAX_LEVEL / 100
      else
        set_state state - MAX_LEVEL / GRADATION_NUMBER
      end
    end
    # Increase brightness level (value 0-100%)
    def bright(value = nil)
      if value
        set_state value * MAX_LEVEL / 100
      else
        set_state state + MAX_LEVEL / GRADATION_NUMBER
      end
    end
    def fade_in(sec = 4)
      Thread.new do
        set_state MIN_LEVEL
        GRADATION_NUMBER.times do
          bright
          sleep(sec.to_f / GRADATION_NUMBER)
        end
      end
    end
    def fade_out(sec = 4)
      Thread.new do
        set_state MAX_LEVEL
        GRADATION_NUMBER.times do
          dim
          sleep(sec.to_f / GRADATION_NUMBER)
        end
      end
    end
    def fade_to(value = MAX_LEVEL / 2, sec = 2, steps = GRADATION_NUMBER)
      Thread.new do
        p step_size = ((value - state) / steps.to_f).round
        delay = sec / steps.to_f
        steps.times do
          set_state state + step_size
          sleep delay
        end
      end
    end
  end
end