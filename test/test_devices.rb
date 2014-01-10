ENV['RACK_ENV'] = 'test'

require "test/unit"
require "./app.rb"

class DomoticsDevicesTestCase < Test::Unit::TestCase
end