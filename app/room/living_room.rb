module Domotics
  class LivingRoom < Room
    def light(action = :toggle)
      case action
      when :up
        return board_light.on if long_side_light.on?
        return long_side_light.on if board_wardrobe_light.on?

        board_wardrobe_light.on
      when :down
        return board_window_light.off unless board_window_light.off?
        return long_side_light.off unless long_side_light.off?
        board_wardrobe_light.off
      end
      super
    end
    def event_handler(msg = {})
      event, element = msg[:event], msg[:element]
      case element.state
      when :tap then light :up
      when :long_tap then light :toggle
      when :long_tap_x2 then light :toggle; play.light :toggle
      end
      super
    end
  end
end
