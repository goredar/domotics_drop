#!/usr/bin/ruby -w
# coding: utf-8

require 'open-uri'
require 'socket'

module Domotics
  # Configuration
  CONF_BASE = 'http://127.0.0.1/configure/'
  SERVER_PORT = 50002
  PROTOCOL_VERSION = '1'
  
  class DomServer
    def initialize
      show_exception_in_threads
      # Create devices, rooms and elements
      for file in %w(devices.conf rooms.conf elements.conf) do
        open(CONF_BASE+file) do |f|
          Marshal.load(f.read).each { |x| eval %Q{ #{x[:klass]}.new(#{x[:options]}) } }
        end
      end
    end
    def show_exception_in_threads
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
    end
    def start
      server = TCPServer.new SERVER_PORT
      loop do
        Thread.start(server.accept) do |client|
          client.puts Marshal.dump version: 'GDS '+Domotics::PROTOCOL_VERSION
          loop do
            break if !message = Marshal.load(client.gets.chop)
            case message[:request]
            when :get
              client.puts Marshal.dump response: :ok
            when :set
              client.puts Marshal.dump response: :ok
            when :script
              client.puts Marshal.dump response: :ok
            when :quit
              client.puts Marshal.dump response: :bye
              break
            when :test
              client.puts Marshal.dump response: :ok
            when :debug
              client.puts Marshal.dump response: :ok
            else
              client.puts Marshal.dump response: :unknown
              break
            end
          end
        end
      end
    end
  end
end