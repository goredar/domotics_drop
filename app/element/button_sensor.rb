#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class ButtonSensor < Element
    include Arduino::NOSensor

    def set_state(*args)
      nil
    end
    
    def on_state_changed(value)
      
    end
  end
end