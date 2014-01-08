ENV['RACK_ENV'] = 'test'

require "test/unit"
require "./app.rb"

class DomoticsTestCase < Test::Unit::TestCase
  def test_core
    ### Arduino board
    ard = Domotics::Device[:nano]
    assert ard.set_pwm_frequency 11, 1
    assert ard.set_pwm_frequency 11, 3
    ### Dimmer
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
    ### RGBLedStrip
    rgb = Domotics::Room[:test].rgb
    rgb.off
  end

  def test_button
    btn = Domotics::Room[:test].btn
    $emul.toggle_pin 7
    sleep 0.1
    $emul.toggle_pin 7
    #assert_equal :state_changed, Domotics::Room[:test].last_event[0]
    $emul.toggle_pin 7
    sleep 0.6
    $emul.toggle_pin 7
    #assert_equal :state_changed, Domotics::Room[:test].last_event
    $emul.toggle_pin 7
    sleep 0.1
    $emul.toggle_pin 7
    sleep 0.1
    $emul.toggle_pin 7
    sleep 0.1
    $emul.toggle_pin 7
    #assert_equal :state_changed, Domotics::Room[:test].last_event
  end
  
  def test_room
    tr = Domotics::Room.new name: :tr
    assert_raise NoMethodError do
      tr.instance_eval "no_method :args"
    end
    assert_nothing_raised do
      tr.instance_eval "nothing.off"
      tr.instance_eval "nothing.light :off"
    end
  end
end