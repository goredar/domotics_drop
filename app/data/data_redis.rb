#!/usr/bin/ruby -w
# coding: utf-8

require 'redis'

module Domotics
  class DataRedis
    def initialize(host = nil, port = nil)
      if host and port
        @redis = Redis.new :host => host, :port => port
      else
        @redis = Redis.new
      end
    end
    def []=(room, element, state)
      @redis.set "#{room}:#{element}", state.to_s
    end
    def [](room, element)
      result = @redis.get("#{room}:#{element}")
      begin
        result && Integer(result)
      rescue
        result.to_sym
      end
    end
  end
end
