module Domotics
  class Device
    @@devices = {}
    attr_reader :name, :type
    def initialize(args = {})
      @@devices[@name = args[:name]] = self
      @type = args[:type]
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