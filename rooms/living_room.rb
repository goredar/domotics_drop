class LivingRoom < Domotics::Core::Room
  def light(action = :toggle)
    case action
    when :up
      [
        board_sofa_light,
        short_side_light,
        board_tv_light,
        window_side_light,
        door_side_light,
      ].select(&:off?).first.on rescue light :off
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
    when :long_tap_x2 then light :off; play.light :off
    end
    super
  end
end
