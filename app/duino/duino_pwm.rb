#!/usr/bin/ruby -w
# coding: utf-8

class DuinoPWM
  def initialize(board, room, args_hash = {})
    @board, @pin = DuinoBoard[board], args_hash[:pin]
    Room[room].add_element self, args_hash[:name]
  end
rescue ArgumentError => e
  $stderr.puts e.message
  nil
end