#!/usr/bin/ruby -w
# coding: utf-8

require 'redis'
require 'hiredis'

module Domotics
  class DataRedis

    def initialize(args = {})
      @args = Hash.new
      @args[:host] = args[:host]
      @args[:port] = args[:port]
      @args[:driver] = :hiredis
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
  end
end
