#!/usr/bin/ruby -w
# coding: utf-8

module Domotics
  class Setup
    CLASS_MAP = {
      # Rooms
      home: [:room, "Domotics::Home"], # Meta-room. Represents all rooms and executes scenarios.
      kitchen: [:room, "Domotics::Kitchen"],
      bathroom: [:room, "Domotics::Bathroom"],
      wc: [:room, "Domotics::WaterCloset"],
      hall: [:room, "Domotics::Hall"],
      playroom: [:room, "Domotics::Playroom"],
      living_room: [:room, "Domotics::LivingRoom"],
      test_room: [:room, "Domotics::TestRoom"],
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
      @current_room = Hash.new
      @current_device = Hash.new
      instance_eval(&block) if block_given?
    end

    def room(class_name, name, args = {})
      @current_room[:name] = args[:name] = name
      @current_room[:type] = args[:type]
      eval %Q{ #{class_name}.new(args) } unless Room[name]
      yield if block_given?
      @current_room.clear
    end

    def device(class_name, name, args = {})
      @current_device[:name] = args[:name] = name
      @current_device[:type] = args[:type]
      eval %Q{ #{class_name}.new(args) } unless Device[name]
      yield if block_given?
      @current_device.clear
    end

    def element(class_name, name, args = {})
      raise "Element must have device and room" unless @current_device.any? and @current_room.any?
      args[:name] = name
      args[:room] = @current_room[:name]
      args[:room_type] = @current_room[:type]
      args[:device] = @current_device[:name]
      args[:device_type] = @current_device[:type]
      eval %Q{ #{class_name}.new(args) } unless Room[@current_room[:name]][name]
    end

    def method_missing(object, *args, &block)
      if CLASS_MAP[object]
        args << Hash.new unless args[1]
        args[1][:type] = object
        args[1][:logger] = $logger
        public_send(*CLASS_MAP[object], *args, &block)
      else
        super
      end
    end
  end
end