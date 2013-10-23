#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Playroom < Room
    def light(action = :off)
      if action == :off
        rgb_strip.off
      end
      super
    end
  end
end