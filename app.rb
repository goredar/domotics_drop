#!/usr/bin/env ruby
# coding: utf-8

require 'bundler/setup'
require 'rack'
require 'domotics/arduino'
require 'logger'

app_path = File.dirname(__FILE__)

#require '../domotics-arduino/lib/domotics/arduino'
Dir["#{app_path}/app/data/*.rb"].each {|file| require file}
Dir["#{app_path}/app/*.rb"].each {|file| require file}

[:device, :room, :element].each do |x|
  Dir["#{app_path}/app/#{x}/*.rb"].each do |file|
    cn = nil
    index = nil
    require file
    IO.read(file).each_line do |line|
      if line =~ /class\s*([A-Z]\w*)[\s\w<]*(#__as__ :(\w*))?/
        cn, index = $1, $3 && $3.to_sym
        break
      end
    end
    next unless cn
    index ||= cn.split(/(?=[A-Z])/).map{ |cnp| cnp.downcase }.join('_').to_sym
    Domotics::CLASS_MAP[index] = [x, Domotics.const_get(cn)]
  end
end

# Create logger
$logger = Logger.new(STDERR)
$logger.level = Logger::DEBUG if ENV['RACK_ENV'] == 'test'
#$logger.formatter = proc do |severity, datetime, progname, msg|
#  "#{severity} #{msg}#{$/}"
#end

# Set data store
Domotics::Element.data = Domotics::DataRedis.new

if ENV['RACK_ENV'] == 'test'
  $emul = Domotics::Arduino::BoardEmulator.new
  conf = "#{app_path}/conf/config.test.rb"
else
  conf = "#{app_path}/conf/config.rb"
end

Domotics::Setup.new IO.read(conf)

builder = Rack::Builder.new do
  use Rack::CommonLogger
  use Rack::ContentLength
  passwd = IO.read("#{app_path}/conf/passwd").each_line.reduce(Hash.new) do |pw, line|
    user, pass = line.chomp.split(" : ")
    pw[user] = pass
    pw
  end
  use Rack::Auth::Basic, "Domotics access" do |username, password|
    passwd[username] == password
  end
  use Rack::Reloader, 0
  use Rack::ShowExceptions
  use Rack::Lint
  run Domotics::Server.new
end
Rack::Handler::Thin.run builder, :Host => 'localhost', :Port => 9292 unless ENV['RACK_ENV'] == 'test'
