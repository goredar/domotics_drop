#!/usr/bin/ruby -w
# coding: utf-8

require "serialport"
require "thread"

module Arduino

  class ArduinoSerialError < StandardError; end

  class ArduinoSerial
    # Constants from Arduino
    LOW = 0
    HIGH = 1
    STATES = [LOW, HIGH]
    INPUT = 0
    OUTPUT = 1
    INPUTPULLUP = 2
    MODES = [INPUT, OUTPUT, INPUTPULLUP]
    # Replies from board
    SUCCESSREPRLY = 2
    FAILREPRLY = 3
    # Board events
    EVENTS = {'0' => :pinstate}
    # Commands for board
    SETPINMODE = 0
    GETDIGITAL = 1
    SETDIGITAL = 2
    GETADC = 3
    SETPWM = 4
    GETWATCH = 5
    SETWATCH = 6
    ECHOREPLY = 7
    DEFAULTS = 8
    # Watch states
    WATCHOFF = 0
    WATCHON = 1
    W_STATES = [WATCHOFF, WATCHON]

    def initialize(args_hash = {})
      # grab args from hash
      b_type = args_hash[:type] || :mega
      case b_type
      when :nano
        port_str = args_hash[:port] || "/dev/ttyUSB0"
        @hard_reset = true
        @number_of_pins = 22
        # todo: address of last 2 pins on nano???
        @adc_pins = Array.new(8) { |index| 14+index }
        @pwm_pins = [2,5,6,9,10,11]
      when :mega
        port_str = args_hash[:port] || "/dev/ttyACM0"
        @hard_reset = false
        @number_of_pins = 70
        @adc_pins = Array.new(16) { |index| 54+index }
        @pwm_pins = Array.new(12) { |index| 2+index } + [44,45,46]
      else
        raise ArduinoSerialError, 'Error! Invalid board type.'
      end
      # Open connection
      baudrate = 115200; databits = 8; stopbits = 1; parity = SerialPort::NONE
      @board = SerialPort.new(port_str, baudrate, databits, stopbits, parity)
      @board.read_timeout = 0
      @board.sync = true
      # Not allow multiple command sends
      @command_lock = Mutex.new
      @reply = Queue.new
      # Listen for board replies and alarms
      Thread.new do
        loop do
          message = @board.gets
          raise ArduinoSerialError if !message # message nil - board disconected
          message = message.split
          case message.length
          when 1
            @reply.push(message[0].to_i)
          when 3
            event_handler :event => EVENTS[message[0]], :pin => message[1].to_i, :state => message[2].to_i
          when 2
            @reply.push(message.collect{ |m| m.to_i })
          else
            raise ArduinoSerialError
          end
        end
      #rescue ArduinoSerialError => e
        #@reply.push(FAILREPRLY) if @command_lock.locked?
      end
      # Reset the board
      reset
    end
    
    # ---0--- SETPINMODE 
    def set_mode(pin, mode)
      check_pin(pin); check_pin_watch(pin); raise ArgumentError, 'Error! Invalid mode.' unless MODES.include? mode
      warn 'Warning! already set mode.' if @pin_mode[pin] == mode
      @pin_mode[pin] = mode
      send_command(SETPINMODE, pin, mode)
    end
    def set_input_pullup(pin)
      set_mode(pin, INPUTPULLUP)
    end
    
    # ---1--- GETDIGITAL
    def get_digital(pin)
      check_pin(pin)
      send_command(GETDIGITAL, pin)
    end
    
    # ---2--- SETDIGITAL
    def set_digital(pin, state)
      check_pin(pin); check_pin_watch(pin); raise ArgumentError, 'Error! Invalid state.' unless STATES.include? state
      set_mode(pin, OUTPUT) unless @pin_mode[pin] == OUTPUT
      send_command(SETDIGITAL, pin, state)
    end
    def set_high(pin)
      set_digital(pin, HIGH)
    end
    def set_low(pin)
      set_digital(pin, LOW)
    end

    # ---3--- GETADC
    def get_adc(pin)
      check_pin(pin); raise ArgumentError, 'Error! Not ADC pin.' unless @adc_pins.include? pin
      send_command(GETADC, pin)
    end
    
    # ---4--- SETPWM
    def set_pwm(pin, value)
      check_pin(pin); check_pin_watch(pin); raise ArgumentError, 'Error! Not PWM or DAC pin.' unless @pwm_pins.include? pin
      raise ArgumentError, 'Error! Invalid PWM value' unless value.is_a(Integer) and value>=0 and value<=255
      send_command(SETPWM, pin, value)
    end
    
    # ---5--- GETWATCH
    def get_watch(pin)
      check_pin(pin)
      send_command(GETWATCH, pin)
    end
    
    # ---6--- SETWATCH
    def set_watch(pin, watch)
      check_pin(pin); raise ArgumentError, 'Error! Invalid watch mode.' unless W_STATES.include? watch
      warn 'Warning! already set watch mode' if @watch_list[pin] == watch
      set_mode(pin, INPUT) if @pin_mode[pin] == OUTPUT
      @watch_list[pin] = watch
      send_command(SETWATCH, pin, watch)
    end

    def close
      @board.close
    end
    # Default event handler simple prints event.
    def event_handler(hash)
      puts hash
    end

    private

    # Send command directly to board
    def send_command(command, pin = 0, value = 0)
      @command_lock.synchronize do
        @board.puts("#{command} #{pin} #{value}")
        # Get reply
        case reply = @reply.pop
        when 0
          0
        when 1
          1
        when SUCCESSREPRLY
          true
        when FAILREPRLY
          false
        when Array
          reply
        else
          nil
        end
      end
    end
    # Reset board
    def reset
      $stderr.print("#{Time.new.strftime("%F %T: ")}Initializing...")
      # Pin states and mods
      @pin_mode = Array.new(@high_pin+1, INPUT)
      @watch_list = Array.new(@high_pin+1, WATCHOFF)
      # Hard reset board
      if @hard_reset
        @board.dtr = 0
        sleep(2)
      end
      $stderr.puts("OK!")
      $stderr.print("#{Time.new.strftime("%F %T: ")}Reset to defaults...")
      if send_command(DEFAULTS)
        $stderr.puts("OK!")
      else
        $stderr.puts("Error!")
        raise ArduinoSerialError, 'Error! Can not reset board.'
      end
      $stderr.print("#{Time.new.strftime("%F %T: ")}Checking connection...")
      random = Random.new
      a, b = 2.times.map { random.rand(0..9) }
      if send_command(ECHOREPLY, a, b) == [b, a]
        $stderr.puts("OK!")
      else
        $stderr.puts("Error!")
        raise ArduinoSerialError, 'Error! Bad reply from board.'
      end
    end
    # Checks
    def check_pin(pin)
      raise ArgumentError, 'Error! Invalid pin number.' unless pin.is_a(Integer) and pin>=0 and pin<@number_of_pins
    end
    def check_pin_watch(pin)
      raise ArgumentError, 'Error! Cant access watched pin.' if @watch_list[pin] == WATCHON
    end
    
  rescue ArgumentError => e
    $stderr.puts e.message
    nil
  end
end