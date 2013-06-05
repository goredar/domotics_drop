#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Room
    # All rooms
    @@rooms = {}
    def initialize(args_hash = {})
      # Save self
      @@rooms[args_hash[:name]] = self
      # Hash of elements
      @elements = {}
      # New queue thread
      @room_queue = Queue.new
      @queue_thread = Thread.new { loop { on_event @room_queue.pop } }
    end
    # Register element
    def register_element(element, name)
      @elements[name] = element
      # Add method with the same name as elements symbol
      instance_eval %Q{def #{name}; @elements[:#{name}]; end;}
    end
    def light(action = :toggle)
      case action
      when :on
        @elements.values.reject{ |v| v.state == :on }.each{ |e| e.on }
      when :off
        @elements.values.reject{ |v| v.state == :off }.each{ |e| e.off }
      when :toggle
        @elements.values.each { |e| e.on? ? e.off : e.on }
      end
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
    def destroy
      @queue_thread.exit
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
      return @@rooms[symbol] if @@rooms[symbol]
      #return self[symbol] if self[symbol]
      super
    end
  end
end