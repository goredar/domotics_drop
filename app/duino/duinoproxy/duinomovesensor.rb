#!/usr/bin/ruby -w
# coding: utf-8

# Normal_open sensor
class DuinoMoveSensor < DuinoDigital
  def initialize(*args)
    super
    # Hardware init
    @board.set_watch @pin, DuinoSerial::WATCHON
  end
  #
  def pinstate_to_state(pin_state)
    pin_state == 0 ? :nomove : :move
  end
  def move?
    @state == :move
  end
end
