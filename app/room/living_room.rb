module Domotics
  class LivingRoom < Room
    def light(action = :toggle)
      case action
      when :up
        return light :on if long_side_light.on?
        return long_side_light.on if center_light.on?
        return door_side_light.on unless door_side_light.on?
        return window_side_light.on unless window_side_light.on?
      when :down
        [:short_side_light, :long_side_light, :window_side_light, :door_side_light].each do |light|
          eval %Q{ return #{light}.off unless #{light}.off? }
        end
      end
      super
    end
    def event_handler(msg)
      event, element = *msg
      case element.state
      when :tap then light :up
      when :long_tap then light :off
      end
    end
  end
end