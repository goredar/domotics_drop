#!/usr/local/rvm/rubies/ruby-1.9.3-p448/bin/ruby
# coding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'rack'

# Debug - Show exception in threads
Thread.class_eval do
  alias_method :initialize_without_exception_show, :initialize
  def initialize(*args, &block)
    initialize_without_exception_show(*args) do
      begin
        block.call
      rescue Exception => e
        $logger.error e
        $logger.debug e.backtrace.join
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
$logger.level = Logger::DEBUG if ENV['RACK_ENV'] == 'test'
$logger.formatter = proc do |severity, datetime, progname, msg|
  "#{severity} #{msg}\n"
end
# Set data store
Domotics::Element.data=Domotics::DataRedis.new

if ENV['RACK_ENV'] == 'test'
  require "#{File.dirname(__FILE__)}/test/config.test.rb"
else
  require "#{File.dirname(__FILE__)}/config.rb"
end

builder = Rack::Builder.new do
    use Rack::CommonLogger
    use Rack::ContentLength
  if ENV['RACK_ENV'] == 'test'
    use Rack::Reloader, 0
    use Rack::ShowExceptions
    use Rack::Lint
  end
  run Domotics::Server.new
end
Rack::Handler::Thin.run builder, :Host => 'localhost', :Port => 9292 unless ENV['RACK_ENV'] == 'test'