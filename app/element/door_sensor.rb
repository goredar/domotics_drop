#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class DoorSensor < Element
    include Arduino::NCSensor
    def state
      super == :on ? :open : :close
    end
    def state=(*args)
      nil
    end
  end
end