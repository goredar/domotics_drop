module Domotics
  class ReedSwitch < Element
    def initialize(args = {})
      @type = args[:type] || :reed_switch
      if args[:device_type]
        eval_str = %(include Domotics::#{args[:device_type].capitalize}::NCSensor)
        self.class.class_eval(eval_str, __FILE__, __LINE__)
      end
      super
    end
    #def to_hls(state)
    #  super == :on ? :open : :close
    #end
    def set_state(*args)
      nil
    end
  end
end
