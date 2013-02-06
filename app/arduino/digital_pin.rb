#!/usr/bin/ruby -w
# coding: utf-8

# Digital pin
module Arduino
  class DigitalPin
    def initialize(board, pin_number, bind_element = nil)
      @board, @pin, @bind_element = DuinoBoard[board], pin_number, bind_element
      @board.register_pin self, @pin
    end
    def state
      convert_state @board.get_digital @pin
    end
    def state=(value)
      @board.set_digital @pin, convert_state value
    end
    def on_state_changed(pin_state)
      @bind_element.on_event event: :state_changed, value: convert_state pin_state if !@bind_element
    end
    def bind_element(element)
      @bind_element = element
    end
    
    private
    
    def convert_state(value)
      case value
      when ArduinoSerial::LOW
        :off
      when :off
        ArduinoSerial::LOW
      when ArduinoSerial::HIGH
        :on
      when :on
        ArduinoSerial::HIGH
      else
        raise ArgumentError 'Invalid state to convert'
      end
    end
  rescue ArgumentError => e
    $stderr.puts e.message
    nil
  end
end