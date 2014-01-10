module Domotics
  class LivingRoom < Room
    def light(action = :toggle)
      case action
      when :up
        #return light :on if long_side_light.on?
        return board_light.on if long_side_light.on?
        return long_side_light.on if board_wardrobe_light.on?
        #return board_tv_light.on if board_wardrobe_light.on?
        board_wardrobe_light.on
      when :down
        [:board_window_light, :long_side_light, :board_wardrobe_light].each do |light|
          eval %{ return #{light}.off unless #{light}.off? }
        end
      end
      super
    end
    def event_handler(msg = {})
      event, element = msg[:event], msg[:element]
      case element.state
      when :tap then light :up
      when :long_tap then light :off
      end
      super
    end
  end
end
