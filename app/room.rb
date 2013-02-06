#!/usr/bin/ruby -w
# coding: utf-8

class Room
  @@rooms = {}

  def initialize(symbol, args_hash)
    @@rooms[symbol] = self
    # Hash of elements
    @elements = {}
    # Men count (0 -> nil)
    @men = nil
    # New queue thread
    @room_queue = Queue.new
    Thread.new {loop {on_event @room_queue.pop}}
  end
  # Register element
  def add_element(element, name)
    name = name.to_sym unless name.is_a? Symbol
    @elements[name] = element
    # Add method with the same name as elements symbol
    instance_eval %Q{def #{name}; @elements[:#{name}]; end;}
  end
  # Return element object
  def [](symbol)
    @elements[symbol]
  end
  # Method for pushing into queue
  def push(*args)
    @room_queue.push(*args)
  end
  # Default simple prints event
  def on_event(hash)
    puts hash
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