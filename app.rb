#!/usr/local/rvm/rubies/ruby-1.9.3-p448/bin/ruby
# coding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'rack'

require 'domotics/arduino'

#require '../domotics-arduino/lib/domotics/arduino'

# Debug - Show exception in threads
Thread.class_eval do
  alias_method :initialize_without_exception_show, :initialize
  def initialize(*args, &block)
    initialize_without_exception_show(*args) do
      begin
        block.call
      rescue Exception => e
        $logger.error e
        $logger.debug { e.backtrace.join }
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
  require "#{File.dirname(__FILE__)}/conf/config.test.rb"
else
  require "#{File.dirname(__FILE__)}/conf/config.rb"
end

builder = Rack::Builder.new do
  use Rack::CommonLogger
  use Rack::ContentLength
  passwd = IO.read("#{File.dirname(__FILE__)}/conf/passwd").each_line.reduce(Hash.new) do |pw, line|
    user, pass = line.chomp.split(" : ")
    pw[user] = pass
    pw
  end
  use Rack::Auth::Basic, "Domotics access" do |username, password|
    passwd[username] == password
  end
  if ENV['RACK_ENV'] == 'test'
    use Rack::Reloader, 0
    use Rack::ShowExceptions
    use Rack::Lint
  end
  run Domotics::Server.new
end
Rack::Handler::Thin.run builder, :Host => 'localhost', :Port => 9292 unless ENV['RACK_ENV'] == 'test'