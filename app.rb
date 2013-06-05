#!/usr/bin/ruby
# coding: utf-8

require 'rack'

# Debug - Show exception in threads
Thread.class_eval do
  alias_method :initialize_without_exception_show, :initialize
  def initialize(*args, &block)
    initialize_without_exception_show(*args) do
      begin
        block.call
      rescue Exception => e
        $logger.error e.message
        raise e
      end
    end
  end
end
# Require subtree
Dir[File.dirname(__FILE__) + '/app/**/*.rb'].sort.each {|file| require file}
# Create logger
require 'logger'
$logger = Logger.new(STDERR)
$logger.level = Logger::DEBUG
$logger.formatter = proc do |severity, datetime, progname, msg|
  "#{severity} #{msg}\n"
end

require './config.rb'

builder = Rack::Builder.new do
  use Rack::Reloader, 0
  use Rack::ContentLength
  use Rack::CommonLogger
  use Rack::ShowExceptions
  use Rack::Lint
  run Domotics::Server.new
end
#Rack::Handler::Thin.run builder, :Port => 9292