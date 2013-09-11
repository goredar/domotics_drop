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
      rescue
        return invalid 'request'
      end
      ok object.verbose_state.to_json
    end
    def invalid(param='argument')
      [400, {"Content-Type" => "text/html"}, ["Processing error: invalid #{param}."]]
    end
    def ok(param='OK')
      [200, {"Content-Type" => "text/html"}, [param]]
    end
  end
end