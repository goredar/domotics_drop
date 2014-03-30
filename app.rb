#!/usr/bin/env ruby
# coding: utf-8

app_path = File.dirname(__FILE__)

require 'bundler/setup'
require 'optparse'
#require "../domotics-core/lib/domotics/core"
require 'domotics/core'
require 'rack'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: app [options]"
  opts.on("-d", "--debug", "Run in debug mode") do |v|
    options[:debug] = v
  end
  opts.on("-c", "--config FILE", "Set config file location") do |file|
    options[:config] = file
  end
end.parse!

Dir["#{app_path}/rooms/*.rb"].each do |file|
  Domotics::Core.add_map type: :room, file: file, realm: Object
end

require "#{app_path}/conf/app.conf.rb"

conf = options[:config] || "#{app_path}/conf/config.rb"
Domotics::Core::Setup.new IO.read(conf)

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
  #use Rack::ShowExceptions
  #use Rack::Lint
  run Domotics::Core::Server.new
end
Rack::Handler::Thin.run builder, :Host => 'localhost', :Port => 9292
