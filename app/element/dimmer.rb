#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Dimmer < Element
    include Arduino::PWMPin
    GRADATION_NUMBER = 16
    DEFAULT_LEVEL = 0
    MIN_LEVEL = 0
    MAX_LEVEL = 255
    def initialize(args_hash = {})
      super
      set_level level || DEFAULT_LEVEL
    end
    def level
      @@data[@room.name, "#{@name}_level"]
    end
    def set_level(value = DEFAULT_LEVEL)
      value = 0 if !(value.is_a? Integer) or (value < 0)
      value = 255 if value > 255
      @@data[@room.name, "#{@name}_level"] = value if super value
    end
    # Decrease brightness level (value 0-100%)
    def dim(value = nil)
      if value
        set_level value*256/100
      else
        set_level @level-256/GRADATION_NUMBER
      end
    end
    # Increase brightness level (value 0-100%)
    def bright(value = nil)
      if value
        set_level value*256/100
      else
        set_level  @level+256/GRADATION_NUMBER
      end
    end
    def fade_in(sec = 4)
      Thread.new do
        set_level MIN_LEVEL
        GRADATION_NUMBER.times do
          bright
          sleep(sec/GRADATION_NUMBER)
        end
      end
    end
    def fade_out(sec = 4)
      Thread.new do
        set_level MAX_LEVEL
        GRADATION_NUMBER.times do
          dim
          sleep(sec/GRADATION_NUMBER)
        end
      end
    end
  end
end