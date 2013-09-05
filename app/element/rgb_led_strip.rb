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
      if @r_strip.state == Dimmer::MIN_LEVEL and @g_strip.state == Dimmer::MIN_LEVEL and @b_strip.state == Dimmer::MIN_LEVEL
        :off
      else
        :on
      end
    end

    def set_state(value=nil)
      case value
      when :off, nil
        set_color Dimmer::MIN_LEVEL,Dimmer::MIN_LEVEL,Dimmer::MIN_LEVEL
      when :on
        set_color Dimmer::MAX_LEVEL,Dimmer::MAX_LEVEL,Dimmer::MAX_LEVEL
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

    def color
      [@r_strip.state, @g_strip.state, @b_strip.state]
    end

    def set_color(*args)
      args=args[0] if args.size == 1 and args[0].is_a? Array
      if args.size == 3
        @r_strip.set_state args[0]
        @g_strip.set_state args[1]
        @b_strip.set_state args[2]
      end
    end

    def randomize
      set_color 3.times.map { rand Dimmer::MAX_LEVEL }
    end

    def set_power(value=50)
      return unless value.is_a? Integer
      value=100 if value>100
      value=0 if value<0
      set_color color.map { |c| c*Dimmer::MAX_LEVEL*value/color.max/100 }
    end
  end
end