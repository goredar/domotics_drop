module Domotics
  class ElementGroup < BasicObject
    attr_reader :name, :type, :room, :elements
    def initialize(args = {})
      #::Object.instance_method(:is_a?).bind(self)
      @name = args[:name] || :undefined
      @room = Room[args[:room]]
      @room.register_element self, @name
      @elements = []
      @type = :group
    end
    def add_element(element)
      @elements << element
    end
    def verbose_state
      { @room.name =>
        { :elements =>
          { @name =>
            { :state => nil }
          }
        }
      }
    end
    def method_missing(method, *args, &block)
      if @elements.map{ |el| el.respond_to? method }.reduce{ |res, n| res && n }
        @elements.map{ |el| el.public_send method, *args, &block }.reduce{ |res, n| res && n }
      else
        super
      end
    end
    def respond_to?(method)
      @elements.map{ |el| el.respond_to? method }.reduce{ |res, n| res && n } || super
    end
    def to_s
      "Group :#{@name} -> #{@elements}"
    end
  end
end