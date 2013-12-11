#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class MoveSensor < Element
    def initialize(args = {})
      self.class.instance_eval %Q{include Domotics::#{args[:device_type].capitalize}::NOSensor}
    end
    def to_hls(state)
      super == :on ? :move : :no_move
    end
    def set_state(*args)
      nil
    end
  end
end