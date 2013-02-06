#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Room
    @@rooms = {}

    def initialize(args_hash = {})
      name = args_hash[:name]
      @@rooms[name] = self
      # Hash of elements
      @elements = {}
      # New queue thread
      @room_queue = Queue.new
      Thread.new {loop {on_event @room_queue.pop}}
    end
    # Register element
    def register_element(element, name)
      @elements[name] = element
      # Add method with the same name as elements symbol
      instance_eval %Q{def #{name}; @elements[:#{name}]; end;}
    end
    # Return element object
    def [](symbol)
      @elements[symbol]
    end
    # Method for pushing into queue
    def push_event(*args)
      @room_queue.push(*args)
    end
    # Default simple prints event
    def on_event(element)
      puts element
    end
    def inform(element)
      p "#{element.name} -> #{element.state}"
    end

    # Return requested room
    def self.[](symbol)
      @@rooms[symbol]
    end

    # Like var
    def method_missing(symbol)
      @@rooms[symbol]
    end
  end
end