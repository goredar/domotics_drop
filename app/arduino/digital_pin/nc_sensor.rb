#!/usr/bin/ruby -w
# coding: utf-8

module Arduino
  # Normal_close sensor
  class NCSensor < DigitalPin
    def initialize(*args)
      super
      @board.set_input_pullup @pin
      @board.set_watch @pin, DuinoSerial::WATCHON
    end
  end
end