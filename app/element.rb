#!/usr/bin/ruby -w
# coding: utf-8

require 'open-uri'

module Domotics
  class Element
    def initialize(args_hash = {})
      @room = Room[args_hash[:room]]
      @room.register_element self, args_hash[:name]
      @db_id = args_hash[:id]
      if args_hash[:state]
        self.state=(args_hash[:state].to_sym)
      else
        @state = :off
      end
    end
    def state
      @state
    end
    def state=(value)
      AElement.update(@db_id, :state => value.to_s)
      ARoom.update(@room.db_id, :last_update => (Time.now.to_f*1000).to_i)
      @state = value
    end
    def on_state_changed(pin_state)
      @state = to_hls pin_state
      @room.notify self.dup
    end
    def to_hls(value)
      value
    end
  end
end