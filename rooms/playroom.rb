class Playroom < Domotics::Core::Room
  def light(action = :toggle)
    case action
    when :off
      rgb_strip.off
    when :up
      [
        window_side_light,
	door_side_light,
      ].select(&:off?).first.on rescue light :off
    when :down
      #return center_light.off unless center_light.off?
      return window_side_light.off unless window_side_light.off?
      door_side_light.off
    end
    super
  end
  def event_handler(msg = {})
    event, element = msg[:event], msg[:element]
    case element.state
    when :tap then light :up
    when :long_tap then light :toggle
    when :long_tap_x2 then light :off; live.light :off
    end
    super
  end
end
