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
    get '/kt/main_light'
    assert last_response.bad_request?
  end
  def test_switch_element
    get '/kt/main_light?on&1'
    assert last_response.ok?
    sleep 2
    get '/kt/main_light?delay_on&1'
    assert last_response.ok?
    sleep 2
    get '/kt/main_light?off'
    assert last_response.ok?
    3.times do
      sleep 1
      get '/kt/main_light?switch'
      assert last_response.ok?
    end
    get '/kt/main_light?delay_switch&1'
    assert last_response.ok?
    sleep 2
  end
end