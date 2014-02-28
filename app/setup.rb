# coding: utf-8
module Domotics
  CLASS_MAP = {group: :element_group}
  class Setup < BasicObject
    def initialize(conf)
      @current_room = {}
      @current_device = {}
      @groups = []
      instance_eval conf, __FILE__, __LINE__
    end

    def element_group(args = {})
      raise "Element group must have room" unless @current_room.any?
      args[:room] = @current_room[:name]
      unless gr = Room[@current_room[:name]][args[:name]]
        gr = ElementGroup.new args
        @groups[-1].add_element gr if @groups[-1]
      end
      @groups.push(gr)
      yield if ::Kernel.block_given?
      @groups.pop
    end

    def room(klass, args = {})
      @current_room[:name] = args[:name]
      @current_room[:type] = args[:type]
      klass.new(args) unless Room[args[:name]]
      yield if ::Kernel.block_given?
      @current_room.clear
    end

    def device(klass, args = {})
      @current_device[:name] = args[:name]
      @current_device[:type] = args[:type]
      klass.new(args) unless Device[args[:name]]
      yield if ::Kernel.block_given?
      @current_device.clear
    end

    def element(klass, args = {})
      raise "Element must have room" unless @current_room.any?
      args[:room] = @current_room[:name]
      args[:room_type] = @current_room[:type]
      args[:device] = @current_device[:name]
      args[:device_type] = @current_device[:type]
      klass = klass.dup if args[:device_type]
      el = klass.new(args) unless Room[@current_room[:name]][args[:name]]
      @groups[-1].add_element el if @groups[-1]
    end

    def method_missing(symbol, *args, &block)
      if CLASS_MAP[symbol] and name = args.shift
        args_hash = args.shift || {}
        args_hash[:name] = name
        args_hash[:type] = symbol if CLASS_MAP[symbol][0] != :element
        args_hash[:logger] = $logger
        __send__(*CLASS_MAP[symbol], args_hash, &block)
      else
        super
      end
    end
  end
end
