#!/usr/bin/ruby -w
# coding: utf-8

require 'json'

class String
  def to_isym
    begin
      Integer(self)
    rescue ArgumentError
      self.to_sym
    end
  end
end

module Domotics
  class Server
    def call(env)
      # [object]/[action]/[params]
      request = env['PATH_INFO'][1..-1].split('/')
      object = request.shift
      return invalid 'room' unless object and object = Room[object.to_sym]
      return invalid 'element or action' unless object_action = request.shift
      if sub_object = object[object_action.to_isym]
        room, object = object, sub_object
        action = request.shift
      else
        room = object
        action = object_action
      end
      return invalid 'action' unless action and object.respond_to? action
      begin
        object.public_send(action, *request.map { |param| param.to_isym })
      rescue Exception => e
        if ENV['RACK_ENV'] == 'test'
          $logger.error e
          $logger.debug { e.backtrace.join("\n") }
        end
        return invalid 'request'
      end
      return ok object.verbose_state.to_json
    end
    def invalid(param)
      [400, {"Content-Type" => "text/html"}, ["Processing error: invalid #{param}."]]
    end
    def ok(param)
      [200, {"Content-Type" => "text/html"}, [param]]
    end
  end
end