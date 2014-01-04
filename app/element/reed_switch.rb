module Domotics
  class ReedSwitch < Element
    def initialize(args = {})
      self.class.class_eval %Q{include Domotics::#{args[:device_type].capitalize}::NCSensor}
    end
    def to_hls(state)
      super == :on ? :open : :close
    end
    def set_state(*args)
      nil
    end
  end
end