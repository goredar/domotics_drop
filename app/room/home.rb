module Domotics
  class Home < Room

    def light(action = :off)
      case action
      when :off
        [play, live].each { |room| room.light :off }
      end
    end

    def verbose_state
      [play, live].reduce(Hash.new) { |st, room| st.merge! room.verbose_state }
    end
  end
end