#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class MoveSensor < Element
    include Domotics::Arduino::NOSensor
    def to_hls(state)
      super == :on ? :move : :no_move
    end
    def set_state(*args)
      nil
    end
  end
end