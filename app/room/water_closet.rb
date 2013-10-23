#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class WaterCloset < Room
    def on_event(element)
      case element.state
      when :move
        light.on if door.close?
      when :no_move
        nil
      when :open
        light.on 30
      when :close
        light.delay_off 10
      else
        nil
      end
    end
  end
end