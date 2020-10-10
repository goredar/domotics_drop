class Home < Domotics::Core::Room

  def light(action = :off)
    case action
    when :off
      [play, live, hall].each { |room| room.light :off }
    end
  end

  def verbose_state
    [play, live, hall].reduce(Hash.new) { |st, room| st.merge! room.verbose_state }
  end
end
