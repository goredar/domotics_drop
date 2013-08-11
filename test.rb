#!/usr/bin/ruby -w
# coding: utf-8

ENV['RACK_ENV'] = 'test'

require './app.rb'
require 'test/unit'
require 'rack/test'

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Domotics::Server.new
  end

  def test_valid_object
    get '/to_s'
    assert last_response.bad_request?
    get '/room/to_s'
    assert last_response.ok?
    get '/room/light_1/to_s'
    assert last_response.ok?
    get '/invalid_object/to_s'
    assert last_response.bad_request?
    get '/room/invalid_object/to_s'
    assert last_response.bad_request?
  end
  def test_query_action
    get '/room/light_1/state'
    assert last_response.ok?
    get '/room/light_1/abracadabra'
    assert last_response.bad_request?
    get '/room/light_1/state/abracadabra'
    assert last_response.bad_request?
  end
  def test_switch_element
    get '/room/light_1/on'
    assert last_response.ok?
    get '/room/light_1/delay_off/1'
    assert last_response.ok?
    sleep 1
    get '/room/light_1/delay_on/1'
    assert last_response.ok?
    sleep 1
    3.times do
      sleep 1
      get '/room/light_1/switch'
      assert last_response.ok?
    end
    get '/room/light_1/delay_switch/1'
    assert last_response.ok?
    sleep 2
    get '/room/light_1/off'
    assert last_response.ok?
  end
end