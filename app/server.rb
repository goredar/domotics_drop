#!/usr/bin/ruby -w
# coding: utf-8

require 'open-uri'
require 'socket'

module Domotics
  # Configuration
  CONF_BASE = 'http://127.0.0.1/configure/'
  SERVER_PORT = 50002
  PROTOCOL_VERSION = '1.0'
  
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
      Socket.tcp_server_loop(SERVER_PORT) do |client, client_addrinfo|
        Thread.new do
          # client.puts GDS: Domotics::PROTOCOL_VERSION
          $logger.info { "New client connection from #{client_addrinfo.ip_address}:#{client_addrinfo.ip_port} accepted.\n" }
          loop do
            break if !message = client.gets
            begin
              data = eval message
            rescue
              break
            end
            case data[:request]
            # Evaluate expression in term of object
            # { request: :eval, object: :some_object, expression: :some_expression }
            when :eval
              $logger.debug { data.inspect }
              $logger.debug state = Room[data[:object].to_sym].instance_eval(data[:expression])
              client.puts({ :state => state == :on ? :active : nil })
            when :get
            when :set
            when :script
            when :quit
              break
            when :test
            when :debug
            else
              break
            end
          end
        end
      end
    end
  end
end