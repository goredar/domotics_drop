# Debug - Show exception in threads
Thread.class_eval do
  alias_method :initialize_without_exception_show, :initialize
  def initialize(*args, &block)
    initialize_without_exception_show(*args) do
      begin
        block.call
      rescue Exception => e
        $logger.error e
        #$logger.debug { e.backtrace.join }
        raise e
      end
    end
  end
end

class String
  def to_isym
    begin
      Integer(self)
    rescue ArgumentError
      self.to_sym
    end
  end
end


module Domotics
  class BlackHole
    def method_missing(*args)
      self
    end
  end
end

class Object 
  def eigenclass 
    class << self
      self
    end 
  end 
end