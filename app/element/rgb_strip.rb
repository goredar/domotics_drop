module Domotics
  class RgbStrip < Element
    def initialize(args = {})
      @strips = Hash.new
      @crazy_lock = Mutex.new
      @crazy_thread = nil
      super
      sub_args = args.dup
      %w(r g b).each do |x|
        sub_args[:name] = (args[:name].to_s+"_#{x}_strip").to_sym
        sub_args[:pin] = args[x.to_sym]
        @strips[x.to_sym] = Dimmer.new(sub_args)
      end
    end

    def red
      @strips[:r]
    end
    def green
      @strips[:g]
    end
    def blue
      @strips[:b]
    end

    def off
      kill_crazy
      @strips.values.each { |strip| strip.off } if on?
      set_state :off
    end

    def color
      @strips.values.map { |strip| strip.state }
    end

    def on?
      color.reduce(:+) != 0
    end

    def set_color(*args)
      kill_crazy
      args=args[0] if args.size == 1 and args[0].is_a? Array
      if args.size == 3
        @strips[:r].fade_to args[0]
        @strips[:g].fade_to args[1]
        @strips[:b].fade_to args[2]
        set_state args.reduce(:+) == 0 ? :off : :on
      end
    end

    def set_power(value=50)
      return unless value.is_a? Integer
      value=100 if value>100
      value=0 if value<0
      if state == :on
        set_color color.map { |c| c * Dimmer::MAX_LEVEL * value / color.max / 100 }
      else
        set_color 3.times.map { Dimmer::MAX_LEVEL * value / 100 }
      end
    end

    def random
      set_color 3.times.map { rand Dimmer::MAX_LEVEL }
    end

    def crazy
      @crazy_lock.synchronize do
        @crazy_thread.kill if @crazy_thread
        @crazy_thread = Thread.new do
          loop do
            @fade_threads = @strips.values.map { |strip| strip.fade_to(rand(Dimmer::MAX_LEVEL), 1) }
            @fade_threads.each { |thread| thread.join }
          end
        end
      end
      set_state :on
    end

    def kill_crazy
      @crazy_lock.synchronize do
        if @crazy_thread
          @crazy_thread.kill
          @crazy_thread = nil
        end
      end
    end

  end
end
