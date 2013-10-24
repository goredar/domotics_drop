#!/usr/bin/ruby -w
# coding: utf-8

require 'redis'

module Domotics
  class DataRedis

    def initialize(host = nil, port = nil)
      @args = Hash.new
      @args[:host] = host
      @args[:port] = port
      @redis = Redis.new @args
    end

    def []=(room, element, state)
      @redis.set "#{room}:#{element}", state
    end

    def [](room, element)
      result = @redis.get("#{room}:#{element}")
      begin
        return result && Integer(result)
      rescue
        return result.to_sym
      end
    end

    def reconnect
      @redis.quit if @redis
      @redis = Redis.new @args
    end

  end
end
