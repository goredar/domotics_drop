#!/usr/bin/ruby -w
# coding: utf-8

Domotics::Setup.new do
  home 'goredar_home'
  # Room
  playroom 'play' do
    # Device
    arduino 'mega_0', port: '/dev/ttyUSB0', type: :mega do
      # Element
      light 'corner_1_light', pin: 13
      light 'corner_2_light', pin: 14
      light 'corner_3_light', pin: 15
      light 'corner_4_light', pin: 16
      button 'button_1', pin: 2
    end
  end
end