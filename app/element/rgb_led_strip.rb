#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class RGBLedStrip
    def initialize(board, room, args_hash = {})
      @r_strip = DuinoLedStrip.new(board, room, {name: (name+'_r').to_sym, pin: args_hash[:r_pin]})
      @g_strip = DuinoLedStrip.new(board, room, {name: (name+'_g').to_sym, pin: args_hash[:g_pin]})
      @b_strip = DuinoLedStrip.new(board, room, {name: (name+'_b').to_sym, pin: args_hash[:b_pin]})
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
    def set_color(r = 255, g = 255, b = 255, a = 255)
      @r_strip.brightness = r
      @g_strip.brightness = g
      @b_strip.brightness = b
    end
    
  rescue ArgumentError => e
    $stderr.puts e.message
    nil
  end
end