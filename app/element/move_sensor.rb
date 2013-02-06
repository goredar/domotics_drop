#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class MoveSensor < Element
    include Arduino::NOSensor
    def state
      super == :on ? :move : :no_move
    end
    def state=(*args)
      nil
    end
  end
end