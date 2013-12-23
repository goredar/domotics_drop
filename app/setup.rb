module Domotics
  CLASS_MAP = {}
  class Setup < BasicObject
    def initialize(conf)
      @current_room = {}
      @current_device = {}
      instance_eval(conf)
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
      raise "Element must have device and room" unless @current_device.any? and @current_room.any?
      args[:room] = @current_room[:name]
      args[:room_type] = @current_room[:type]
      args[:device] = @current_device[:name]
      args[:device_type] = @current_device[:type]
      klass.new(args) unless Room[@current_room[:name]][args[:name]]
    end

    def method_missing(symbol, *args, &block)
      if CLASS_MAP[symbol] and name = args.shift
        args_hash = args.shift || {}
        args_hash[:name] = name
        args_hash[:type] = symbol
        args_hash[:logger] = $logger
        __send__(*CLASS_MAP[symbol], args_hash, &block)
      else
        super
      end
    end
  end
end