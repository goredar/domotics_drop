#!/usr/bin/ruby -w
# coding: utf-8

class DuinoPWM
  def initialize(board, room, args_hash = {})
    @board, @pin, @room, @name = DuinoBoard[board], args_hash[:pin], Room[room], args_hash[:name]
    raise ArgumentError, 'Error! Pin not specified' unless @pin
    raise ArgumentError, 'Error! Name not specified' unless @name
    @room.add_element self, @name
  end
rescue ArgumentError => e
  $stderr.puts e.message
  nil
end