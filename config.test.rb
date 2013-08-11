#!/usr/bin/ruby -w
# coding: utf-8

Domotics::Setup.new do
  home 'home'
  # Room
  playroom 'room' do
    # Device
    arduino 'nano', type: :nano do
      # Element
      light 'light', pin: 13
    end
  end
end