module Domotics
  class Button < Element
    def initialize(args = {})
      @touch = args[:touch]
      eval_str = %(include Domotics::#{args[:device_type].capitalize}::#{@touch ? 'DigitalSensor' : 'NOSensor'})
      self.class.class_eval eval_str if args[:device_type]
      super
      @taped = true
      #@tap_lock = Mutex.new
    end
    def set_state(*args)
      nil
    end

    def state_changed(value)
      $logger.debug { "#{self}: state[:#{value}]" }
      case value
      when :on
        (@last_on = Time.now; @taped = false) if @taped
      when :off
        case Time.now - (@last_on || Time.now)
        when 0...0.05 then return
        when 0.05...0.5 then super :tap; @taped = true
          #@tap_lock.synchronize do
          #  if @tap and @tap.alive?
          #    @tap.kill
          #    @tap = nil
          #    super :double_tap
          #  else
          #    @tap = Thread.new { sleep 0.25; super :tap }
          #  end
          #end
        else super :long_tap; @taped = true
        end
      end
    end
  end
end
