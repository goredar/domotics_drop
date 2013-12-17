#!/usr/bin/env ruby
# coding: utf-8

require 'bundler/setup'
require 'rack'
require 'domotics/arduino'
#require '../domotics-arduino/lib/domotics/arduino'
require './app/exception'
Dir['./app/**/*.rb'].sort.each {|file| require file}

[:device, :room, :element].each do |x|
  Dir["./app/#{x}/*.rb"].each do |file|
    #require file
    file =~ /\/(\w*)\.rb\Z/
    cn = $1.split(/_/)
    ind = (x == :device and cn[-1] == "board") ? cn[0].to_sym : cn.join('_').to_sym
    Domotics::CLASS_MAP[ind] = [x, eval("Domotics::#{cn.map{ |cn_p| cn_p.capitalize }.join}")]
  end
end


# Create logger
require 'logger'
$logger = Logger.new(STDERR)
$logger.level = Logger::DEBUG if ENV['RACK_ENV'] == 'test'
#$logger.formatter = proc do |severity, datetime, progname, msg|
#  "#{severity} #{msg}#{$/}"
#end

# Set data store
Domotics::Element.data = Domotics::DataMongo.new

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