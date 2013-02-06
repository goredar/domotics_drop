#!/usr/bin/ruby -w
# coding: utf-8

# Require all files in subtree
require 'open-uri'
require 'socket'
require './gconfig'
Dir[File.dirname(__FILE__) + '/app/**/*.rb'].sort.each {|file| require file}

# Show exception in threads
Thread.class_eval do
  alias_method :initialize_without_exception_show, :initialize
  def initialize(*args, &block)
    initialize_without_exception_show(*args) do
      begin
        block.call
      rescue Exception => e
        $stderr.puts e.message
        raise e
      end
    end
  end
end

# Create devices, rooms and elements
for file in %w(devices.conf rooms.conf elements.conf) do
  open(GConfig::CONF_BASE+file) do |f|
    Marshal.load(f.read).each { |x| eval %Q{ #{x[:klass]}.new(#{x[:options]}) } }
  end
end

5.times do
  Domotics::Room[:wc].lights.on
  sleep 1
  Domotics::Room[:wc].lights.off
  sleep 1
end

# Proceed external commands
command_server = TCPServer.open(GConfig::SERVER_PORT)
loop do
  Thread.start(command_server.accept) do |client|
    client.puts 'GDS '+GConfig::PROTOCOL_VERSION
    loop do
      break if !client_string = client.gets.chop
      client_request = client_string.split
      case client_request[0]
      when 'GET'
        client.puts 'OK'
      when 'SET'
        client.puts 'OK'
      when 'SCRIPT'
        client.puts 'OK'
      when 'QUIT'
        client.puts 'BYE'
        break
      when 'TEST'
        client.puts 'OK'
      when 'DEBUG'
        client.puts 'OK'
      else
        client.puts 'UNKNOWN'
        break
      end
    end
  end
end
