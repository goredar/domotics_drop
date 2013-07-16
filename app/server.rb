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
      # [PATH_INFO]?[QUERY_STRING] = [object]?[action]&[params]
      request = env['PATH_INFO'][1..-1].split('/')
      query = env['QUERY_STRING'].split('&').collect { |q| q.to_isym }
      responce = Hash.new
      return invalid 'object' unless (1..2).include? request.size
      object = request.shift.to_sym
      # Only room???
      return invalid 'object' unless object = Room[object] || Device[object] || (self if object == :self)
      if sub_object = request.shift
        object, grand_object = object[sub_object.to_isym], object
        return invalid 'object' unless object
      end
      return invalid 'query action' unless (action = query.shift) and (object.respond_to? action)
      begin
        responce[:responce] = object.public_send(action, *query)
      rescue
        return invalid 'request'
      end
      if object.respond_to?(:[])
        responce[object.name] = object[].values.inject(Hash.new) { |memo, el| memo[el.name] = el.state if el.respond_to? :state; memo }
        return ok responce.to_json
      end
      responce[grand_object.name] = { object.name => object.state } if object.respond_to? :state
      ok responce.to_json
    end
    def invalid(param='argument')
      [400, {"Content-Type" => "text/html"}, ["Processing error: invalid #{param}."]]
    end
    def ok(param='OK')
      [200, {"Content-Type" => "text/html"}, [param.to_s]]
    end
  end
end