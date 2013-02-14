#!/usr/bin/ruby -w
# coding: utf-8

# Simple switch
module Domotics
  class Switch < Element
    include Arduino::DigitalPin
    MINIMUM_LAG = 1
    def initialize(args_hash = {})
      super
      # Identifier of lag thread
      @lag = nil
      @switch = self
    end
    def on(timer = nil)
      self.state = :on
      lag(:off, timer)
    end
    def delay_on(timer)
      lag(:on, timer)
    end
    def off(timer = nil)
      self.state = :off
      lag(:on, timer)
    end
    def delay_off(timer)
      lag(:off, timer)
    end
    def switch(timer = nil)
      self.state = self.state == :off ? :on : :off
      lag(:switch, timer)
    end
    def delay_switch(timer)
      lag(:switch, timer)
    end
    def lag(action = nil, timer = nil)
      # Kill previous action -> out of date
      @lag.kill if @lag
      raise ArgumentError unless (timer.is_a?(Integer) and timer >= MINIMUM_LAG)
      # Delayed action
      @lag = Thread.new do
        sleep timer
        @switch.public_send action
      end
    rescue ArgumentError
      nil
    end
  end
end
