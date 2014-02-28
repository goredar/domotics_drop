ENV['RACK_ENV'] = 'test'

require "test/unit"
require "./app.rb"

class DomoticsElementsTestCase < Test::Unit::TestCase
  def test_dimmer
    dimmer = Domotics::Room[:test].dimmer
    # Should turn on max and convert state to int
    dimmer.set_state :on
    assert_equal 255, dimmer.state
    # Should turn off and convert state to int
    dimmer.set_state :off
    assert_equal 0, dimmer.state
    # Dim
    [0,3,24,127,237,255].each do |val|
      dimmer.set_state val
      assert_equal val, dimmer.state
    end
    # Off
    dimmer.off
    assert_equal 0, dimmer.state
    # Fade to
    dimmer.fade_to 255
    sleep 1.6
    assert_equal 255, dimmer.state
    dimmer.fade_to 127
    sleep 0.8
    assert_equal 127, dimmer.state
    dimmer.fade_to 0
    sleep 0.8
    assert_equal 0, dimmer.state
  end

  def test_rgb_strip
    rgb = Domotics::Room[:test].rgb
    rgb.on
    sleep 1.6
    assert_equal 255, rgb.red.state
    rgb.off
    assert_equal 0, rgb.red.state
    assert_equal :dimmer, rgb.red.type
    assert_equal :dimmer, rgb.green.type
    assert_equal :dimmer, rgb.blue.type
  end

  def test_button
    btn = Domotics::Room[:test].button
    $emul.set_internal_state 6, 1
    $emul.toggle_pin 6
    sleep 0.1
    $emul.toggle_pin 6
    sleep 0.05
    assert_equal Domotics::Room[:test].last_event(btn.name), :state_changed => :tap
    $emul.toggle_pin 6
    sleep 0.6
    $emul.toggle_pin 6
    sleep 0.01
    assert_equal Domotics::Room[:test].last_event(btn.name), :state_changed => :long_tap
  end
end
