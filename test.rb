#!/usr/bin/ruby -w
# coding: utf-8

require './app.rb'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Domotics::Server.new
  end

  def test_path_deep_1_or_2
    get '/?to_s'
    assert last_response.bad_request?
    get '/kt/?to_s'
    assert last_response.ok?
    get '/kt/main_light?to_s'
    assert last_response.ok?
    get '/kt/main_light/off?to_s'
    assert last_response.bad_request?
  end
  def test_valid_object
    get '/self?to_s'
    assert last_response.ok?
    get '/mega_0?to_s'
    assert last_response.ok?
    get '/mega_0/13/?to_s'
    assert last_response.ok?
    get '/omg_158/?to_s'
    assert last_response.bad_request?
    get '/omg_158/362?to_s'
    assert last_response.bad_request?
  end
  def test_query_action
    get '/kt/main_light?state'
    assert last_response.ok?
    get '/kt/main_light?abracadabra'
    assert last_response.bad_request?
  end
  def test_flash
    get '/kt?light&on'
    assert last_response.ok?
    sleep 1
    get '/kt?light&off'
    assert last_response.ok?
  end
end