#!/usr/bin/ruby -w
# coding: utf-8

class DuinoRGBLedStrip
  def initialize(board, room, args_hash = {})
    @r_strip = DuinoLedStrip.new(board, room, {name: (name+'_r_strip_part').to_sym, pin: args_hash[:r_pin]})
    @g_strip = DuinoLedStrip.new(board, room, {name: (name+'_g_strip_part').to_sym, pin: args_hash[:g_pin]})
    @b_strip = DuinoLedStrip.new(board, room, {name: (name+'_b_strip_part').to_sym, pin: args_hash[:b_pin]})
    Room[room].add_element self, args_hash[:name]
  end
  def red
    @r_strip
  end
  def green
    @g_strip
  end
  def blue
    @b_strip
  end
end