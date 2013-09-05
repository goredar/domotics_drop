ENV['RACK_ENV'] = 'test'

require "test/unit"
require "./app.rb"

class TrackTestCase < Test::Unit::TestCase
  def test_dimmer
=begin
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
    # Fade to
    dimmer.set_state :off
    dimmer.fade_to 255, 2, 8
    7.times do |n|
      sleep 0.125
      assert_equal 32 * (n + 1), dimmer.state
      sleep 0.125
    end
    sleep 0.125
    assert_equal 255, dimmer.state
    
    dimmer.set_state 100
    dimmer.fade_to 200, 2, 20
    20.times do |n|
      sleep 0.051
      assert_equal 100 + 5 * (n + 1), dimmer.state
      sleep 0.05
    end
    dimmer.set_state 100
    dimmer.fade_to 0, 2, 10
    10.times do |n|
      sleep 0.1
      assert_equal 100 - 10 * (n + 1), dimmer.state
      sleep 0.1
    end
#  end

#  def test_rgb_led_strip
    rgb = Domotics::Room[:test_room].rgb
    Domotics::Room[:test_room].rgb_r_strip.set_state :off
    Domotics::Room[:test_room].rgb_g_strip.set_state :off
    Domotics::Room[:test_room].rgb_b_strip.set_state :off
    # On test
    rgb.set_state :on
    sleep 2.1
    assert_equal :on, rgb.state
    assert_equal [255,255,255], rgb.color
    # Off test
    rgb.set_color 0,0,0
    sleep 2.1
    assert_equal :off, rgb.state
    assert_equal [0,0,0], rgb.color
    # On test
    rgb.set_color 255,0,0
    sleep 2.1
    assert_equal :on, rgb.state
    assert_equal [255,0,0], rgb.color
    # Color test
    rgb.set_color [0,127,255]
    sleep 2.1
    assert_equal :on, rgb.state
    assert_equal [0,127,255], rgb.color
    # Color and power test
    rgb.set_color [127,80,0]
    rgb.set_power 100
    assert_equal [255,160,0], rgb.color
    rgb.set_power 50
    assert_equal [127,80,0], rgb.color
    # Power test
    rgb.set_state :off
    rgb.set_power 100
    assert_equal [255,255,255], rgb.color
    # Crazy test
=end
    rgb = Domotics::Room[:test_room].rgb
    Domotics::Room[:test_room].rgb_r_strip.set_state :off
    Domotics::Room[:test_room].rgb_g_strip.set_state :off
    Domotics::Room[:test_room].rgb_b_strip.set_state :off
    rgb.crazy
    sleep 10
    assert_not_equal [0,0,0], rgb.color
    rgb.set_state :off
    sleep 2.1
    assert_equal [0,0,0], rgb.color
    sleep 2.1
    assert_equal [0,0,0], rgb.color
  end
end