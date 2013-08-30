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
      dimmer 'dim', pin: 2
      rgb_strip 'rgb', r: 9, g: 10, b: 11
    end
  end
end