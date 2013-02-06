#!/usr/bin/ruby -w
# coding: utf-8

# Digital pin
module Arduino
  class DigitalPin
    def initialize(board, pin_number)
      @board, @pin = DuinoBoard[board], pin_number
      @board.register_pin self, @pin
    end
    def state
      pinstate_to_state(@board.get_digital(@pin))
    end
    def state=(state)
      case state
    end
    # Watch alarm from board
    def pinstate_changed(pin_state)
      # convert state
      @state = pinstate_to_state(pin_state)
      # Tell about changes
      @room.push self.dup
    end
    
    private
    
    # Translate pin state to element state
    def pinstate_to_state(pin_state)
      pin_state == 0 ? :off : :on
    end
    
  rescue ArgumentError => e
    $stderr.puts e.message
    nil
  end
end