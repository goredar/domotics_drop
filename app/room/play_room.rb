#!/usr/bin/ruby -w
# coding: utf-8

# Water Closet
module Domotics
  class Playroom < Room
    def light(action = :off)
      if action == :off
        rgb_strip.off if rgb_strip.respond_to? action
      end
      super
    end
  end
end