#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class RGBLedStrip < Element
    def initialize(args_hash = {})
      %w(r g b).each do |x|
        instance_eval %Q{ @#{x}_strip = Dimmer.new({ device: args_hash[:device], room: args_hash[:room],
        name: (args_hash[:name].to_s+'_#{x}_strip').to_sym, pin: args_hash[:#{x}] }) }
      end
      super
    end
    def state
      if @r_strip.state == 0 and @g_strip.state == 0 and @b_strip.state == 0
        :off
      else
        :on
      end
    end
    def set_state(value)
      case value
      when :off
        set_color 0,0,0
      when :on
        set_color
      end
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
    def color(format="h")
    end
    def set_color(r = 255, g = 255, b = 255)
      @r_strip.set_state r
      @g_strip.set_state g
      @b_strip.set_state b
    end
  end
end