module Domotics
  class MotionSensor < Element
    def initialize(args = {})
      if args[:device_type]
        eval_str = %(include Domotics::#{args[:device_type].capitalize}::DigitalSensor)
        self.class.class_eval(eval_str, __FILE__, __LINE__)
      end
      super
    end
    #def to_hls(state)
    #  super == :on ? :move : :no_move
    #end
    def set_state(*args)
      nil
    end
  end
end