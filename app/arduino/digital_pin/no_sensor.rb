#!/usr/bin/ruby -w
# coding: utf-8

module Arduino
  # Normal_open sensor
  module NOSensor
    include DigitalPin
    def initialize(args_hash = {})
      super
      @board.set_watch @pin, ArduinoSerial::WATCHON
    end
  end
end
