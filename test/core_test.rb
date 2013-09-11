ENV['RACK_ENV'] = 'test'

require "test/unit"
require "./app.rb"

class DomoticsTestCase < Test::Unit::TestCase
  def test_dimmer
    ### Dimmer tests
    dimmer = Domotics::Room[:test_room].dim
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
    # Fade to
    dimmer.set_state :off
    dimmer.fade_to 255
    sleep 1
    assert_equal 255, dimmer.state
    dimmer.fade_to 127
    sleep 0.5
    assert_equal 127, dimmer.state
    dimmer.fade_to 0
    sleep 0.5
    assert_equal 0, dimmer.state

    ### RGBLedStrip tests
    rgb = Domotics::Room[:test_room].rgb
    rgb.off
  end
end