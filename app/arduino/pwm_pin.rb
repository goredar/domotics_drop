#!/usr/bin/ruby -w
# coding: utf-8

class DuinoPWM
  def initialize(board, pin_number)
    @board, @pin = DuinoBoard[board], pin_number
  end
  
rescue ArgumentError => e
  $stderr.puts e.message
  nil
end