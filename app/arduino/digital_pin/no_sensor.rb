#!/usr/bin/ruby -w
# coding: utf-8

module Arduino
  # Normal_open sensor
  class NOSensor < DigitalPin
    def initialize(*args)
      super
      @board.set_watch @pin, DuinoSerial::WATCHON
    end
  end
end