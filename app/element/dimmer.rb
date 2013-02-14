#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Dimmer < Element
    include Arduino::PWMPin
    GRADATION = 16
    DEFAULT_LEVEL = 50
    def initialize(*args)
      super
      @level = DEFAULT_LEVEL
    end
    def level
      @level
    end
    def level=(value = DEFAULT_LEVEL)
      @level = value if super
    end
    def dim(value = nil)
      if value
        self.level = value
      else
        self.level -= 100/GRADATION
      end
    end
    def bright(value = nil)
      if value
        self.level = value
      else
        self.level += 100/GRADATION
      end
    end
    def fade_in(sec = 4)
      self.level = 0
      GRADATION.times do
        bright
        sleep(sec/GRADATION)
      end
    end
    def fade_out(sec = 4)
      self.level = 100
      GRADATION.times do
        dim
        sleep(sec/GRADATION)
      end
    end
  end
end