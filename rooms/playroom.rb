class Playroom < Domotics::Core::Room
  def light(action = :toggle)
    case action
    when :off
      rgb_strip.off
    when :up
      return center_light.on if corner_light.on?
      return corner_light.on if center_light.on?

      return door_side_light.on unless door_side_light.on?
      window_side_light.on
    when :down
      return center_light.off unless center_light.off?
      return window_side_light.off unless window_side_light.off?
      door_side_light.off
    end
    super
  end
end
