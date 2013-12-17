#!/usr/bin/ruby -w
# coding: utf-8

# Simple switch
module Domotics
  class Switch < Element
    MINIMUM_LAG = 1
    def initialize(args = {})
      self.class.instance_eval %Q{include Domotics::#{args[:device_type].capitalize}::DigitalPin}
      super
      # Identifier of lag thread
      @lag = nil
      @lag_lock = Mutex.new
    end
    def on(timer = nil)
      set_state :on
      lag(:off, timer)
      state
    end
    def on?
      state == :on
    end
    def delay_on(timer)
      lag(:on, timer)
    end
    def off(timer = nil)
      set_state :off
      lag(:on, timer)
      state
    end
    def off?
      state == :off
    end
    def delay_off(timer)
      lag(:off, timer)
    end
    def switch(timer = nil)
      set_state state == :off ? :on : :off
      lag(:switch, timer)
      state
    end
    def delay_switch(timer)
      lag(:switch, timer)
    end

    private

    def lag(action = nil, timer = nil)
      # Kill previous action -> out of date
      @lag_lock.synchronize do
        if @lag and @lag.alive?
          @lag.kill
          @lag = nil
        end
        raise ArgumentError unless (timer.is_a?(Integer) and timer >= MINIMUM_LAG)
        # Delayed action
        @lag = Thread.new do
          sleep timer
          public_send action
        end
      end
    rescue ArgumentError
      nil
    end
  end
end