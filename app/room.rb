#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Room
    # All rooms
    @@rooms = Hash.new
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
    def verbose_state
      { @name =>
        { :elements =>
            @elements.inject(Hash.new) { |hash, element| hash.merge element[1].verbose_state[@name][:elements] },
          :state => state,
          :info => (info if respond_to? :info)
        }
      }
    end
    def state
      nil
    end
    # Perform action with light
    def light(action = :switch)
      return unless [:on, :off, :switch].include? action
      @elements.each do |name, element|
        next unless element.kind_of? PowerSwitch
        next unless name =~ /light/
        if element.respond_to? ask_action = (action.to_s+'?').to_sym
          next if element.public_send ask_action
        end
        element.public_send action
      end
    end

    # Method for pushing into queue
    def notify(msg)
      @room_queue.push(msg)
    end
    # Default - simple prints event
    def on_event(msg)
      event, element = msg
      case element
      when Dimmer
      else
        $logger.info { "[#{@name}]: event message [#{event}] from [#{element.name}] with state [#{element.state}]" }
      end
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
    def method_missing(symbol, *args)
      super unless args.size == 0
      @@rooms[symbol] || BlackHole.new
    end
  end
end