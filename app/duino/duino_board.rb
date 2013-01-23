#!/usr/bin/ruby -w
# coding: utf-8

# Serial communicarion + Elements and boards knowing
class DuinoBoard < DuinoSerial
  @@boards = {}

  def initialize(b_name = :board007, args_hash)
    # Array of element objects
    @elements = []
    @@boards[b_name] = self
    super(args_hash)
  end
  # Add new element on specified pin
  def add_element(element, pin)
    @elements[pin] = element
  end
  # Return element on requested pin
  def [](pin)
    @elements[pin]
  end
  # Override default handler
  def event_handler(hash)
    case hash[:event]
    # Tell element to change state
    when :pinstate
      @elements[hash[:pin]].pinstate_changed hash[:state]
    when :boardreset
      nil
    else
      nil
    end
  end

  def self.[](symbol)
    @@boards[symbol]
  end
end