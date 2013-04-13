#!/usr/bin/ruby -w
# coding: utf-8

require 'open-uri'

module Domotics
  class Element
    def initialize(args_hash = {})
      @room = Room[args_hash[:room]]
      @room.register_element self, args_hash[:name]
      @web_id = args_hash[:id]
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
      #Thread.new { web_notify value }
      AElement.update(@id, :state => value.to_s)
      @state = value
    end
    def on_state_changed(pin_state)
      @state = to_hls pin_state
      @room.notify self.dup
    end
    def web_notify(value)
      notify = "#{Domotics::WEB_SERVER}elements/notify/#{@web_id}/#{value}"
      open(URI(notify))
    rescue Exception => e
      $logger.error e.message
      nil
    end
  end
end