#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Home < Room

    def light(action = :off)
      case action
      when :off
        [playroom, living_room].each { |room| room.light :off }
      end
    end

    def verbose_state
      [playroom, living_room].reduce(Hash.new) { |st, room| st.merge! room.verbose_state }
    end

  end
end