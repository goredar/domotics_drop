#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Dimmer < Element
    include Arduino::PWMPin
    GRADATION_NUMBER_NUMBER = 16
    DEFAULT_LEVEL = 0
    MIN_LEVEL = 0
    MAX_LEVEL = 256
    def initialize(args_hash = {})
      super
      set_level args_hash[:level] || DEFAULT_LEVEL
    end
    def level
      @level
    end
    def set_level(value = DEFAULT_LEVEL)
      @level = value if super
    end
    def dim(value = nil)
      if value
        set_level value
      else
        level -= 256/GRADATION_NUMBER
      end
    end
    def bright(value = nil)
      if value
        set_level value
      else
        self.level += 256/GRADATION_NUMBER
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