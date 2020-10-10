class Kitchen < Domotics::Core::Room

  def event_handler(msg = {})
    event, element = msg[:event], msg[:element]
    case element.state
    when :tap then main_light.toggle
    when :long_tap then bath.bath_light.toggle
    end
    super
  end


end
