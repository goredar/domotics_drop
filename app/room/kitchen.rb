#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Kitchen < Room
    def on_event(element)
      p "#{element.name}:#{element.state}"
    end
  end
end