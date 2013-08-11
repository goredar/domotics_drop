#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Setup
    CLASS_MAP = {
      # Rooms
      home: [:room, "Domotics::Home"], # Meta-room. Represents all rooms and executes scenarios.
      kitchen: [:room, "Domotics::Kitchen"],
      wc: [:room, "Domotics::WaterCloset"],
      playroom: [:room, "Domotics::PlayRoom"],
      livingroom: [:room, "Domotics::LivingRoom"],
      # Devices
      arduino: [:device, "Domotics::ArduinoBoard"],
      # Elements
      light: [:element, "Domotics::PowerSwitch"],
      button: [:element, "Domotics::ButtonSensor"],
      door: [:element, "Domotics::DoorSensor"],
      move: [:element, "Domotics::MoveSensor"],
      dimmer: [:element, "Domotics::Dimmer"],
      rgb_strip: [:element, "Domotics::RGBLedStrip"],
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
      raise "Element must have device and room" unless @current_device and @current_room
      args[:name] = name
      args[:room] = @current_room
      args[:device] = @current_device
      eval %Q{ #{class_name}.new(#{args}) } unless Room[@current_room][name]
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