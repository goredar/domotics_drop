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

# Create devices and rooms
for file in %w(devices.conf rooms.conf) do
  open(GConfig::CONF_BASE+file) do |f|
    Marshal.load(f.read).each { |name, conf| eval %Q{#{conf[:class]}.new :#{name}, #{conf[:options]}}}
  end
end
# and elements
open(GConfig::CONF_BASE+'elements.conf') do |f|
  Marshal.load(f.read).each { |x| eval %Q{#{x[:class]}.new :#{x[:device]}, :#{x[:room]}, #{x[:options]}}}
end

# Proceed external commands
command_server = TCPServer.open(50002)
loop do
  Thread.start(command_server.accept) do |client|
    client.puts 'GDS '+GConfig::PROTOCOL_VERSION
    loop do
      break if !client_strinng = client.gets.chop
      client_request = client_strinng.split
      puts client_request[0]
    end
  end
end