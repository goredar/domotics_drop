#!/usr/bin/ruby -w
# coding: utf-8

# Water Closet
module Domotics
  class PlayRoom < Room
    def on_event(element)
    end
    def lights_min
      @elements.each do | name, element |
        if name == :main_lights
          Thread.new { element.on; ActiveRecord::Base.connection.close } unless element.on?
        else
          Thread.new { element.off; ActiveRecord::Base.connection.close } if element.on?
        end
      end
      :ok
    end
    def lights_mid
      @elements.each do | name, element |
        case name.to_s
        when /main/, /corner_/
          Thread.new { element.on; ActiveRecord::Base.connection.close } unless element.on?
        else
          Thread.new { element.off; ActiveRecord::Base.connection.close } if element.on?
        end
      end
      :ok
    end
  end
end