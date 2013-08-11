#!/usr/bin/ruby -w
# coding: utf-8

Domotics::Setup.new do
  home 'goredar_home'
  # Room
  playroom 'play' do
    # Device
    arduino 'mega_0', port: '/dev/mega_0', type: :mega do
      # Element
      light 'corner_1_light', pin: 4
      light 'corner_2_light', pin: 5
      light 'corner_3_light', pin: 6
      light 'corner_4_light', pin: 7
      button 'button_1', pin: 2
      light 'living_room_light', pin: 14
    end
  end
end