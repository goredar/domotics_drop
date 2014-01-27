module Domotics
  class Element
    @@data = DataHash.new
    attr_reader :name, :type, :room

    def initialize(args = {})
      @room = Room[args[:room]]
      @room.register_element self, @name = args[:name]
      @type = args[:type]
      set_state(self.state || :off)
    end

    def state
      @@data[self].state
    end

    def verbose_state
      { @room.name =>
        { :elements =>
          { @name =>
            { :state => state,
              :info => (info if respond_to? :info)
            }
          }
        }
      }
    end

    def set_state(value)
      @@data[self].state = value
      @room.notify({ event: :state_set, element: self }) unless @type == :dimmer
    end

    def state_changed(value)
      @@data[self].state = value
      @room.notify event: :state_changed, element: self
    end

    def self.data=(value)
      @@data = value
    end

    def to_s
      "Element[#{@room.name}@#{@name}](id:#{__id__})"
    end
  end
end