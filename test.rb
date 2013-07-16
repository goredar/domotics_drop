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
    get '/kt/to_s'
    assert last_response.ok?
    get '/kt/main_light/to_s'
    assert last_response.ok?
    get '/invalid_object/to_s'
    assert last_response.bad_request?
    get '/kt/invalid_object/to_s'
    assert last_response.bad_request?
  end
  def test_query_action
    get '/kt/main_light/state'
    assert last_response.ok?
    get '/kt/main_light/abracadabra'
    assert last_response.bad_request?
    get '/kt/main_light/state/abracadabra'
    assert last_response.bad_request?
  end
  def test_switch_element
    get '/kt/main_light/on'
    assert last_response.ok?
    get '/kt/main_light/delay_off/1'
    assert last_response.ok?
    sleep 1
    get '/kt/main_light/delay_on/1'
    assert last_response.ok?
    sleep 1
    3.times do
      sleep 1
      get '/kt/main_light/switch'
      assert last_response.ok?
    end
    get '/kt/main_light/delay_switch/1'
    assert last_response.ok?
    sleep 2
    get '/kt/main_light/off'
    assert last_response.ok?
  end
end