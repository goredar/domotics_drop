#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Device
    @@devices = {}
    attr_reader :name
    def initialize(args_hash)
      @@devices[@name = args_hash[:name]] = self
    end

    def self.[](symbol = nil)
      return @@devices[symbol] if symbol
      @@devices
    end

    def destroy
      @@devices[@name] = nil
    end
  end
end