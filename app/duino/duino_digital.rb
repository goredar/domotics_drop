#!/usr/bin/ruby -w
# coding: utf-8

# Digital pin
class DuinoDigital
  def initialize(board, room, args_hash = {})
    # Save parents
    @board, @pin, @room, @name = DuinoBoard[board], args_hash[:pin], Room[room], args_hash[:name]
    # And register
    @board.add_element self, @pin
    @room.add_element self, @name
    # Initial state
    @state = :off
  end
  # Watch alarm from board
  def pinstate_changed(pin_state)
    # convert state
    @state = pinstate_to_state(pin_state)
    # Tell about changes
    @room.push self.dup
  end
  # Translate pin state to element state
  def pinstate_to_state(pin_state)
    pin_state == 0 ? :off : :on
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

rescue ArgumentError => e
  $stderr.puts e.message
  nil
end