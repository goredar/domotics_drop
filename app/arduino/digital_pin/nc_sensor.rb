#!/usr/bin/ruby -w
# coding: utf-8

module Arduino
  # Normal_close sensor
  module NCSensor < DigitalPin
    def initialize(args_hash = {})
      super
      @board.set_input_pullup @pin
      @board.set_watch @pin, DuinoSerial::WATCHON
    end
  end
end