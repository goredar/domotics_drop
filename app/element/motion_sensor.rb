module Domotics
  class MotionSensor < Element
    def initialize(args = {})
      self.class.class_eval %Q{include Domotics::#{args[:device_type].capitalize}::NOSensor} if args[:device_type]
    end
    def to_hls(state)
      super == :on ? :move : :no_move
    end
    def set_state(*args)
      nil
    end
  end
end