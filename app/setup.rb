#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Setup
    CLASS_MAP = {
      kitchen: [:room, 'Domotics::Kitchen'],
      arduino: [:device, 'Domotics::ArduinoBoard'],
      light: [:element, 'Domotics::Switch'],
      }

    def initialize(&block)
      @current_room = nil
      @current_device = nil
      instance_eval(&block) if block_given?
    end
    
    def room(class_name, name, args = {})
      name = name.to_sym
      @current_room = name
      args[:name] = name
      eval %Q{ #{class_name}.new(#{args}) } unless Room[name]
      yield if block_given?
      @current_room = nil
    end
    
    def device(class_name, name, args = {})
      name = name.to_sym
      @current_device = name
      args[:name] = name
      eval %Q{ #{class_name}.new(#{args}) } unless Device[name]
      yield if block_given?
      @current_device = nil
    end
    
    def element(class_name, name, args = {})
      name = name.to_sym
      raise 'Element must have device and room' unless @current_device and @current_room
      args[:name] = name
      args[:room] = @current_room
      args[:device] = @current_device
      eval %Q{ #{class_name}.new(#{args}) }
    end
    
    def method_missing(object, *args, &block)
      if object = CLASS_MAP[object]
        public_send(*object, *args, &block)
      else
        super
      end
    end
  end
end