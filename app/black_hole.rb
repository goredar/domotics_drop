#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class BlackHole
    def method_missing(*args)
      self
    end
  end
end