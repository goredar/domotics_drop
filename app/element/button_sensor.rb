#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class ButtonSensor < Element
    include Arduino::NOSensor
    def initialize(*args)
      super
      @tap = nil
      @tap_lock = Mutex.new
    end
    def set_state(*args)
      nil
    end

    def on_state_changed(value)
      case value
      when :on
        @last_on = Time.now
      when :off
        off_time = Time.now
        case off_time - @last_on
        when 0..0.5
          # Tap
          @tap_lock.synchronize do
            if @tap
              @tap.kill
              @tap = nil
              super :double_tap
            else
              @tap = Thread.new { sleep 0.25; super :tap }
            end
          end
        when 0.51..3.0
          # Long tap
          super :long_tap
        when 3.01..7.0
          # Too long tap
        end
      end
    end
  end
end