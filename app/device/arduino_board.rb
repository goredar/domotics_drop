module Domotics
  class ArduinoBoard < Device #__as__ :arduino
    include Domotics::Arduino::ArduinoBase

    def initialize(args_hash = {})
      @pins = Hash.new
      super
    end

    # Register pin for watch events
    def register_pin(pin_object, number)
      @pins[number] = pin_object
    end

    # Return pin object
    def [](number = nil)
      return @pins[number] if number
      @pins
    end

    private

    # Override default handler
    def event_handler(hash)
      case hash[:event]
        # Tell element to change state
      when :pin_state_changed
        element = @pins[hash[:pin]]
        element.on_state_changed element.to_hls(hash[:state])
      when :malfunction
        nil
      else
        nil
      end
    end
  end
end