#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Dimmer < Element
    include Arduino::PWMPin
    GRADATION = 16
    def initialize(*args)
      super
      @level = 50
    end
    def level
      @level
    end
    def level=(value = nil)
      super
      @level = value
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