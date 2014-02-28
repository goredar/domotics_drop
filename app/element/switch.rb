module Domotics
  class Switch < Element
    MINIMUM_LAG = 1
    def initialize(args = {})
      @type = args[:type] || :switch
      @lag = nil
      @lag_lock = Mutex.new
      if args[:device_type]
        eval_str = %(include Domotics::#{args[:device_type].capitalize}::DigitalPin)
        self.class.class_eval(eval_str, __FILE__, __LINE__)
      end
      @initialized = false
      super
      @initialized = true
    end
    def set_state(value)
      @initialized ? (super unless state == value) : super
    end
    def on(timer = nil)
      set_state :on
      lag(:off, timer)
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
    end
    def off?
      state == :off
    end
    def delay_off(timer)
      lag(:off, timer)
    end
    def toggle(timer = nil)
      set_state state == :off ? :on : :off
      lag(:toggle, timer)
    end
    def delay_toggle(timer)
      lag(:toggle, timer)
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
