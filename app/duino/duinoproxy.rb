#!/usr/bin/ruby -w
# coding: utf-8

# Common Element class
class DuinoProxy
  def initialize(board, room, args_hash)
    # Remember last and previous state time
    @last = {}; @previous = {}
    # Save parents
    @board, @pin, @room, @name = DuinoBoard[board], args_hash[:pin], Room[room], args_hash[:name]
    # And register
    @board.add_element self, @pin
    @room.add_element self, @name
  end
end

# Digital pin
class DuinoDigital < DuinoProxy
  # Add hi-level state
  def initialize(*args)
    super
    @state = :off
  end
  # Watch alarm from board
  def pinstate_changed(pin_state)
    # convert state
    @state = pinstate_to_state(pin_state)
    # remember time
    #@previous[@state], @last[@state] = @last[@state], Time.now
    # Tell about changes
    @room.push self.dup
  end
  # Translate pin state to element state
  def pinstate_to_state(pin_state)
    pin_state == 0 ? :off : :on
  end
  # Last time changed
  def last(symbol = nil)
    if symbol
      @last[symbol]
    else
      @last.values.max
    end
  end
  # Previous time changed
  def previous(symbol = nil)
    if symbol
      @previous[symbol]
    else
      @previous.values.max
    end
  end
  # Get saved hi-level state
  def state
    @state
  end
  # Get hi-level state from board
  def real_state
    @state = pinstate_to_state(@board.get_digital(@pin))
  end
  # Tell the name
  def name
    @name
  end
end

# Analog pin
class DuinoAnalog < DuinoProxy
end
