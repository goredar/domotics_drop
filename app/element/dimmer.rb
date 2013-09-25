#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Dimmer < Element
    include Arduino::PWMPin

    DEFAULT_LEVEL = 0
    MIN_LEVEL = 0
    MAX_LEVEL = 255
    MAX_STEPS = 64
    STEP_DELAY = 0.8 / MAX_STEPS
    STEP_SIZE = ((MAX_LEVEL + 1) / MAX_STEPS.to_f).round

    def set_state(value = DEFAULT_LEVEL)
      if value.is_a? Integer
        value = MIN_LEVEL if value < MIN_LEVEL
        value = MAX_LEVEL if value > MAX_LEVEL
      end
      super value
    end
    # Decrease brightness level (value 0-100%)
    def dim(value = nil)
      if value
        set_state value * MAX_LEVEL / 100
      else
        set_state state - STEP_SIZE
      end
    end
    # Increase brightness level (value 0-100%)
    def bright(value = nil)
      if value
        set_state value * MAX_LEVEL / 100
      else
        set_state state + STEP_SIZE
      end
    end

    def fade_to(value = DEFAULT_LEVEL, speed_divisor = 1)
      Thread.new do
        op = (value - state) >= 0 ? :+ : :-
        steps = ((value - state).abs / STEP_SIZE.to_f).round
        steps.times do
          begin
            set_state(state.public_send(op, STEP_SIZE))
          rescue
            @@data.reconect
            retry
          end
          sleep speed_divisor * STEP_DELAY
        end
      end
    end

  end
end