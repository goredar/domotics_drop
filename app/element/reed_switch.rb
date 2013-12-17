#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class ReedSwitch < Element
    def initialize(args = {})
      self.class.instance_eval %Q{include Domotics::#{args[:device_type].capitalize}::NCSensor}
    end
    def to_hls(state)
      super == :on ? :open : :close
    end
    def set_state(*args)
      nil
    end
  end
end