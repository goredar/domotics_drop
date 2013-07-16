#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Room
    # All rooms
    @@rooms = {}
    attr_reader :name
    def initialize(args_hash = {})
      # Save self
      @@rooms[@name = args_hash[:name]] = self
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
    # Return state of all elements
    def state
      @elements.map { |element| { element.name => element.state }}
    end
    # Perform action with light
    def light(action = :toggle)
      case action
      when :on
        @elements.values.reject{ |v| v.state == :on }.each{ |e| e.on }
      when :off
        @elements.values.reject{ |v| v.state == :off }.each{ |e| e.off }
      when :toggle
        @elements.values.each { |e| e.on? ? e.off : e.on }
      end
      nil
    end
    
    # Method for pushing into queue
    def notify(*args)
      @room_queue.push(*args)
    end
    # Default - simple prints event
    def on_event(element)
      puts element
    end
    def destroy
      @queue_thread.exit
    end
    
    # Return element object
    def [](symbol = nil)
      return @elements[symbol] if symbol
      @elements
    end
    # Return requested room like element of array
    def self.[](symbol = nil)
      return @@rooms[symbol] if symbol
      @@rooms
    end
    # Return requested room like variable
    def method_missing(symbol)
      return @@rooms[symbol] if @@rooms[symbol]
      #return self[symbol] if self[symbol]
      super
    end
  end
end