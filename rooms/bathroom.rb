class Bathroom < Domotics::Core::Room
  def event_handler(msg = {})
    event, element = msg[:event], msg[:element]
    case element.state
    when :tap
      bath_light.toggle
    when :long_tap
      bath_light.toggle
    when :move
#      bath_light.delay_on 0
    when :open
      bath_light.on
    when :close
      #wc_light.delay_off(12) { motion.state == :no_move }
    end
    bath_light.on? ? light_switch_indicator.on : light_switch_indicator.off
    super
  end
end
