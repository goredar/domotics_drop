module Domotics
  class Playroom < Room
    def light(action = :toggle)
      case action
      when :off
        rgb_strip.off
      when :up
        return center_light.on if corner_light.on?
        return corner_light.on if center_light.on?
        return door_side_light.on unless door_side_light.on?
        return window_side_light.on unless window_side_light.on?
      when :down
        [:center_light, :window_side_light, :door_side_light].each do |light|
          eval %Q{ return #{light}.off unless #{light}.off? }
        end
      end
      super
    end
  end
end