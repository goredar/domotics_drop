require 'redis'
require 'hiredis'

module Domotics
  class DataRedis
    def initialize(args = {})
      @args = Hash.new
      @args[:host] = args[:host] || "127.0.0.1"
      @args[:port] = args[:port] || 6379
      @args[:driver] = :hiredis
      @redis = Redis.new @args
    end

    def [](obj)
      case obj
      when Element
        DataRedisOperator.new @redis, "#{obj.room.name}:#{obj.name}"
      end
    end
  end

  class DataRedisOperator < BasicObject
    def initialize(redis, key)
      @redis = redis
      @key = key
    end

    def method_missing(symbol, *args)
      # Setter method [*=(value)]
      if symbol.to_s =~ /.*=\Z/ and args.size == 1
        @redis.set "#{@key}:#{symbol.to_s[0..-2]}", args[0].to_s
      # Getter method (no arguments allowed)
      elsif args.size == 0
        result = @redis.get "#{@key}:#{symbol}"
        # !!!
        #while result =~ /\AOK!\Z/
        #  @redis.quit
        #  @redis = Redis.new @args
        #  result = @redis.get "#{@key}:#{symbol}"
        #end
        result && result.to_isym
      else
        nil
      end
    end
  end
end