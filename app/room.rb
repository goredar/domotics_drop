module Domotics
  class Room
    # All rooms
    @@rooms = Hash.new
    attr_reader :name, :type, :elements
    def initialize(args = {})
      # Save self
      @@rooms[@name = args[:name]] = self
      @type = args[:type]
      # Hash of elements
      @elements = {}
      class << @elements
        def light
          select { |name, element| (element.is_a? Element) and (element.type == :switch) and (name =~ /light/) }
        end
      end
      # New queue thread
      @room_queue = Queue.new
      @queue_thread = Thread.new { loop { event_handler @room_queue.pop } }
    end
    # Register element
    def register_element(element, name)
      @elements[name] = element
      # define accessor method (singleton)
      instance_eval(%(def #{name}; @elements[:#{name}]; end;), __FILE__, __LINE__) unless respond_to? name
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
    def light(action = :toggle)
      case action
      when :on, :off, :toggle
        @elements.light.values.each { |element| element.public_send(action) if element.respond_to? action }
      end
    end
    def light_off?
      @elements.light.values.reduce(true) { |res, el| res && el.off? }
    end
    # Method for pushing into queue
    def notify(msg)
      @room_queue.push(msg)
    end
    # Default - simple prints event
    def event_handler(msg = {})
      event, element = msg[:event], msg[:element]
      $logger.info { "Event message :#{event} from #{element} with state [#{element.state}]" }
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
    def to_s
      "Room[#{@name}](id:#{__id__})"
    end
  end
end