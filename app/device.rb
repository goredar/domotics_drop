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
    def to_s
      "\033[37mRoom[\033[36m:#{@name}\033[37m](id:#{__id__})\033[0m"
    end
  end
end