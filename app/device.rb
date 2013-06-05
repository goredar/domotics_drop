#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Device
    @@devices = {}
    def initialize(args_hash)
      @name = args_hash[:name]
      @@devices[@name] = self
    end

    def self.[](symbol = nil)
      if symbol
        @@devices[symbol]
      else
        @@devices
      end
    end

    def destroy
      @@devices[@name] = nil
    end
  end
end