require 'redis'
require 'hiredis'

module Domotics
  class DataHash
    def initialize
      @store = {}
    end

    def [](obj)
      case obj
      when Element
        DataHashOperator.new self, "#{obj.room.name}:#{obj.name}"
      end
    end
    
    def set(key, value)
      @store[key] = value
    end
    def get(key)
      @store[key]
    end
  end

  class DataHashOperator < BasicObject
    def initialize(hash, key)
      @hash, @key = hash, key
    end

    def method_missing(symbol, *args)
      # Setter method [*=(value)]
      if symbol.to_s =~ /.*=\Z/ and args.size == 1
        @hash.set "#{@key}:#{symbol.to_s[0..-2]}", args[0]
      elsif args.size == 0
        @hash.get "#{@key}:#{symbol}"
      else
        nil
      end
    end
  end
end