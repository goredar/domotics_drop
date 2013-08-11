#!/usr/bin/ruby -w
# coding: utf-8

Domotics::Setup.new do
  home 'goredar_home'
  # Room
  playroom 'play' do
    # Device
    arduino 'nano_0', type: :nano do
      # Element
      light 'corner_1_light', pin: 13
      light 'corner_2_light', pin: 14
      light 'corner_3_light', pin: 15
      light 'corner_4_light', pin: 16
      rgb_strip 'rgb_strip', r: 17, g: 18, b: 19
    end
  end
  livingroom 'living' do
    arduino 'nano_0' do
      light 'center_light', pin: 13
    end
  end
end