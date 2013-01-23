#!/usr/bin/ruby -w
# coding: utf-8

require 'net/http'
require 'uri'

# Hi-level logic
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
    Thread.new {loop {analize @room_queue.pop}}
  end
  # Register element
  def add_element(element, name)
    # !!! avoid dup name
    @elements[name] = element
    # Add method with the same name as elements symbol
    instance_eval %Q{def #{name.to_s}; @elements[:#{name}]; end;}
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
  def analize(hash)
    puts hash
  end
  def inform(element)
    p "#{element.name} -> #{element.state}"
#    Net::HTTP.post_form URI('http://127.0.0.1/main/post_terminal_line'), { :terminal_line =>
#                                                                           "#{element.name} -> #{element.state}" }
  end
  # Is anybody inside the room?
  #def men?
  #  @men
  #end

  # Return requested room
  def self.[](symbol)
    @@rooms[symbol]
  end

  # Like var
  def method_missing(symbol)
    @@rooms[symbol]
  end
end