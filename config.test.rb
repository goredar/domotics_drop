#!/usr/bin/ruby -w
# coding: utf-8

Domotics::Setup.new do
  home 'home'
  # Room
  playroom 'room' do
    # Device
    arduino 'nano', type: :nano do
      # Element
      light 'light_1', pin: 13
      rgb_strip 'rgb', r: 14, g: 15, b: 16
    end
  end
end