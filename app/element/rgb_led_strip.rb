#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class RGBLedStrip
    def initialize(args_hash = {})
      %w(r g b).each do |x|
        instance_eval %Q{ @#{x}_strip = Dimmer.new { device: args_hash[:device], room: args_hash[:room],
        name: (args_hash[:device]+'_#{x}_strip').to_sym, pin: args_hash[:#{x}_pin] } }
      end
      Room[args_hash[:room]].register_element self, args_hash[:name]
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
  end
end