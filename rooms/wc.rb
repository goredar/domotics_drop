class Wc < Domotics::Core::Room
  def event_handler(msg)
    event, element = *msg
    case element.state
    when :move
      light.on if door.close?
    when :no_move
      nil
    when :open
      light.on 30
    when :close
      light.delay_off 10
    else
      nil
    end
  end
end
