class Wc < Domotics::Core::Room
  def event_handler(msg = {})
    event, element = msg[:event], msg[:element]
    case element.state
    when :tap
      wc_light.toggle
    when :long_tap
      wc_light.toggle
    when :move
      wc_light.delay_on 0
    when :open
      wc_light.on
      # wc_light.delay_off 12
      wc_light.delay_off 10
    when :close
      wc_light.delay_off(11) { motion.state == :no_move }
    end
    wc_light.on? ? light_switch_indicator.on : light_switch_indicator.off
    super
  end
end
