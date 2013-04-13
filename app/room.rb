#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Room
    attr_reader :db_id
    # All rooms
    @@rooms = {}
    def initialize(args_hash = {})
      # Save self
      @@rooms[args_hash[:name]] = self
      @db_id = args_hash[:id]
      # Hash of elements
      @elements = {}
      # New queue thread
      @room_queue = Queue.new
      Thread.new { loop { on_event @room_queue.pop } }
    end
    # Register element
    def register_element(element, name)
      @elements[name] = element
      # Add method with the same name as elements symbol
      instance_eval %Q{def #{name}; @elements[:#{name}]; end;}
    end
    def lights_off
      @elements.values.reject{ |v| v.state == :off }.each{ |e| Thread.new { e.off } }
      :ok
    end
    def lights_min
    end
    def lights_mid
    end
    def lights_max
      @elements.values.reject{ |v| v.state == :on }.each{ |e| Thread.new { e.on } }
      :ok
    end
    # Return element object
    def [](symbol)
      @elements[symbol]
    end
    # Method for pushing into queue
    def notify(*args)
      @room_queue.push(*args)
    end
    # Default simple prints event
    def on_event(element)
      puts element
    end
    # Return requested room
    def self.[](symbol = nil)
      if symbol
        @@rooms[symbol]
      else
        @@rooms
      end
    end
    # Like var
    def method_missing(symbol)
      @@rooms[symbol]
    end
  end
end