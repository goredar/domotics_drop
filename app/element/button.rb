module Domotics
  class Button < Element
    def initialize(args = {})
      self.class.class_eval %Q{include Domotics::#{args[:device_type].capitalize}::NCSensor} if args[:device_type]
      super
      @tap = nil
      @tap_lock = Mutex.new
    end
    def set_state(*args)
      nil
    end

    def state_changed(value)
      case value
      when :off
        @last_on = Time.now
      when :on
        off_time = Time.now
        case off_time - @last_on
        when 0..0.5
          # Tap
          @tap_lock.synchronize do
            if @tap and @tap.alive?
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
