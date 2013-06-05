#!/usr/bin/ruby -w
# coding: utf-8

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
      request = env['PATH_INFO'][1..-1].split('/')
      query = env['QUERY_STRING'].split('&').collect { |q| q.to_isym }
      return invalid 'object' unless (1..2).include? request.size
      object = request.shift.to_sym
      return invalid 'object' unless object = Room[object] || Device[object] || (self if object == :self)
      if sub_object = request.shift
        return invalid 'object' unless object = object[sub_object.to_isym]
      end
      action = query.shift
      return invalid 'query action' unless object.respond_to? action
      begin
        object.public_send action, *query
      rescue
        return invalid 'request'
      end
      responce = 'OK!'
      [200, {"Content-Type" => "text/html"}, [responce.to_s]]
    end
    def invalid(param='argument')
      [400, {"Content-Type" => "text/html"}, ["Processing error: invalid #{param}."]]
    end
  end
end