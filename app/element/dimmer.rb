#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class DuinoLedStrip < DuinoPWM
    def initialize(*args)
      super
      # 0-255 - Internal level
      @bright_level = BrightLevel.new
    end

    def brightness
      @bright_level
    end
    def brightness=(value)
      raise ArgumentError, 'Error! Invalid value type' unless value.kind_of? Integer
      @bright_level = BrightLevel.new(value)
      if value == 0
        off
      else
        on
      end
    end
    # 0-100%
    def brightness_percent=(value)
      self.brightness = value*255/100
    end

    alias_method :level, :brightness_percent=
    
    def dim(level = nil)
      if level
        self.brightness_percent = level
      else
        self.brightness -= 256/16
      end
    end
    def bright(level = nil)
      if level
        self.brightness_percent = level
      else
        self.brightness += 256/16
      end
    end

    def on
      @board.set_pwm @pin, @bright_level.to_i
    end
    def off
      @board.set_low @pin
    end

    def fade_in(sec = 4)
      self.brightness_percent = 0
      16.times do
        bright
        sleep(sec/16)
      end
    end
    def fade_out(sec = 4)
      self.brightness_percent = 100
      16.times do
        dim
        sleep(sec/16)
      end
    end
  end

  class BrightLevel
    attr_accessor :level
    
    def initialize(level=255)
      @level = check_256(level.to_i)
    end
    def +(other)
      BrightLevel.new(check_256(self.level+(other.kind_of?(BrightLevel) ? other.level : other)))
    end
    def -(other)
      BrightLevel.new(check_256(self.level-(other.kind_of?(BrightLevel) ? other.level : other)))
    end
    def check_256(level)
      if level < 0
        0
      elsif level > 255
        255
      else
        level
      end
    end
    def coerce(other)
      [BrightLevel.new(other), self]
    end
    def to_s
      @level.to_s
    end
    def to_i
      @level
    end
  end
end