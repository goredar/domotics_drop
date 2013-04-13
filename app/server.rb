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
  AR_CONFIG = '../web/config/database.yml'
  AR_ENV = "production"
  
  class DomServer
    def initialize
      show_exception_in_threads
      # Connect to the Rails database
      ar_connect
      # Create devices, rooms and elements
      ADevice.all.each {|dev| load_device dev }
      ARoom.all.each {|room| load_room room }
      AElement.all.each {|el| load_element el }
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
            $logger.debug { "client request: "+data.inspect }
            case data[:request]
            # Evaluate expression in term of object
            # { request: :eval, object: :some_object, expression: :some_expression }
            when :eval
              begin
                reply = { :reply => find_object(data[:object]).instance_eval(data[:expression]) }
              rescue Exception => e
                 $logger.error e.message
                 reply = { :reply => :fail }
              end
            when :get
            when :set
            when :script
            when :quit
              break
            when :reload_device
              device = ADevice.where(:name => data[:object]).first
              old_dev = find_object(device.name)
              old_dev.destroy if old_dev
              load_device device
              device.elements.each {|el| load_element el }
              reply = { :reply => :done }
            when :reload_room
              room = ARoom.where(:name => data[:object]).first
              old_room = find_object(room.name)
              old_room.destroy if old_room
              load_room room
              room.elements.each {|el| load_element el }
              reply = { :reply => :done }
            when :test
            when :debug
            else
              break
            end
            $logger.debug { "client reply: "+reply.inspect }
            client.puts(reply)
          end
        end
      end
    end
    
    private
    
    # Select object for eval
    def find_object(obj)
      obj = obj.to_sym
      Room[obj] || Arduino::ArduinoBoard[obj]
    end
    # Connect to database
    def ar_connect(env = AR_ENV)
      dbconfig = YAML::load IO.read File.expand_path AR_CONFIG, File.dirname(__FILE__)
      ActiveRecord::Base.establish_connection dbconfig[env]
    end
    def load_device(dev)
      options = get_options(dev.device_type.options, dev.options).merge!(name: dev.name.to_sym)
      eval %Q{ #{dev.device_type.class_name}.new(#{options}) }
    end
    def load_room(room)
      options = get_options(room.room_type.options, room.options).merge!(name: room.name.to_sym, id: room.id)
      eval %Q{ #{room.room_type.class_name}.new(#{options}) }
    end
    def load_element(el)
      options = get_options(el.element_type.options, el.options).merge!(
        name: el.name.to_sym, room: el.room.name.to_sym, device: el.device.name.to_sym, id: el.id, state: el.state)
      eval %Q{ #{el.element_type.class_name}.new(#{options}) }
    end
    def get_options(type_opt = nil, main_opt = nil)
      begin
        options = eval("{#{type_opt}}").merge(eval("{#{main_opt}}"))
      rescue
        options = Hash.new
      end
      options
    end
  end
  # Rails database
  class ADevice < ActiveRecord::Base
    self.table_name = 'devices'
    belongs_to :device_type
    has_many :elements, :class_name => "AElement", :foreign_key => "device_id"
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
    has_many :elements, :class_name => "AElement", :foreign_key => "room_id"
  end
  class RoomType < ActiveRecord::Base
  end
end
