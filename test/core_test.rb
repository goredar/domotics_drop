ENV['RACK_ENV'] = 'test'

require "test/unit"
require "./app.rb"

class TrackTestCase < Test::Unit::TestCase
  def test_dimmer
    dimmer = Domotics::Room[:test_room].dim
    # Should turn on max and convert state to int
    dimmer.set_state :on
    assert_equal 255, dimmer.state
    # Should turn off and convert state to int
    dimmer.set_state :off
    assert_equal 0, dimmer.state
    # Max
    [248,252,255].each do |val|
      dimmer.set_state val
      assert_equal 255, dimmer.state
    end
    # Dim
    [8,127,247].each do |val|
      dimmer.set_state val
      assert_equal val, dimmer.state
    end
    # Min
    [0,3,7].each do |val|
      dimmer.set_state val
      assert_equal 0, dimmer.state
    end
  end
  def test_rgb_led_strip
    rgb = Domotics::Room[:test_room].rgb
    # On-Off test
    rgb.set_state :off
    assert_equal :off, rgb.state
    rgb.set_state :on
    assert_equal :on, rgb.state
    rgb.set_color 0,0,0
    assert_equal :off, rgb.state
    rgb.set_color 255,0,0
    assert_equal :on, rgb.state
    
  end
end