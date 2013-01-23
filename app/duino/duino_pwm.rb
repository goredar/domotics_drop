#!/usr/bin/ruby -w
# coding: utf-8

class DuinoPWM
  def initialize(board, pin)
    @board, @pin = board, pin
  end
  def level=(value)
    @board.set_pwm(@pin, value)
  end
end