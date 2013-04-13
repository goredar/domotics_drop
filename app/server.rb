#!/usr/bin/ruby -w
# coding: utf-8

#require 'open-uri'
require 'socket'
require 'active_record'
require 'yaml'

module Domotics
  # Configuration
  #WEB_SERVER = 'http://127.0.0.1/'
  #CONF_BASE = 'http://127.0.0.1/configure/'
  #CONF_BASE_DEVEL = 'http://127.0.0.1:3000/configure/'
  SERVER_PORT = 50002
  PROTOCOL_VERSION = '1.0'
  AR_CONFIG = 'web/config/database.yml'
  AR_ENV = "production"
  
  class DomServer
    def initialize
      show_exception_in_threads
      # Connect to the Rails database
      ar_connect
      # Create devices, rooms and elements
      ADevice.all.each do |x|
        begin
          opt = eval("{#{x.device_type.options}}").merge(eval("{#{x.options}}"))
        rescue
          opt = Hash.new
        end
        opt.merge! name: x.name.to_sym
        eval %Q{ #{x.device_type.class_name}.new(#{opt}) }
      end
      ARoom.all.each do |x|
        begin
          opt = eval("{#{x.room_type.options}}").merge(eval("{#{x.options}}"))
        rescue
          opt = Hash.new
        end
        opt.merge! name: x.name.to_sym
        eval %Q{ #{x.room_type.class_name}.new(#{opt}) }
      end
      AElement.all.each do |x|
        begin
          opt = eval("{#{x.element_type.options}}").merge(eval("{#{x.options}}"))
        rescue
          opt = Hash.new
        end
        opt.merge! name: x.name.to_sym, room: x.room.name.to_sym, device: x.device.name.to_sym, id: x.id, state: x.state
        eval %Q{ #{x.element_type.class_name}.new(#{opt}) }
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
              $logger.error e.message
              raise e
            end
          end
        end
      end
    end
    def run
      Socket.tcp_server_loop(SERVER_PORT) do |client, client_addrinfo|
        Thread.new do
          # client.puts GDS: Domotics::PROTOCOL_VERSION
          $logger.info { "New client connection from #{client_addrinfo.ip_address}:#{client_addrinfo.ip_port} accepted." }
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
              begin
                $logger.debug { "client request: "+data.inspect }
                reply = { :reply => find_object(data[:object]).instance_eval(data[:expression]) }
                $logger.debug { "client reply: "+reply.inspect }
                client.puts(reply)
              rescue Exception => e
                 $logger.error e.message
                 break
              end
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
    def find_object(obj)
      obj = obj.to_sym
      Room[obj] || ArduinoBoard[obj] || self
    end
    def ar_connect(env = AR_ENV)
      dbconfig = YAML::load IO.read AR_CONFIG
      ActiveRecord::Base.establish_connection dbconfig[env]
    end
  end
  # Rails database
  class ADevice < ActiveRecord::Base
    self.table_name = 'devices'
    belongs_to :device_type
  end
  class DeviceType < ActiveRecord::Base
  end
  class AElement < ActiveRecord::Base
    self.table_name = "elements"
    belongs_to :element_type
    belongs_to :device, :class_name => "ADevice"
    belongs_to :room, :class_name => "ARoom"
  end
  class ElementType < ActiveRecord::Base
  end
  class ARoom < ActiveRecord::Base
    self.table_name = "rooms"
    belongs_to :room_type
  end
  class RoomType < ActiveRecord::Base
  end
end
