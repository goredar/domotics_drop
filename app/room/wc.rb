#!/usr/bin/ruby -w
# coding: utf-8

# Water Closet
module Domotics
  class WC < Room
    def on_event(element)
      case element.state
      when :move
        lights.on if door.close?
      when :no_move
        nil
      when :open
        lights.on 30
      when :close
        lights.delay_off 10
      else
        nil
      end
    end
  end
end