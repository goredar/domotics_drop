#!/usr/bin/ruby -w
# coding: utf-8

# Normal_close sensor
class DuinoDoorSensor < DuinoDigital
  def initialize(*args)
    super
    # Hardware init
    @board.set_input_pullup @pin
    @board.set_watch @pin, DuinoSerial::WATCHON
  end
  #
  def pinstate_to_state(pin_state)
    pin_state == 0 ? :close : :open
  end
  def open?
    @state == :open
  end
  def close?
    @state == :close
  end
end
