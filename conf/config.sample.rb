#!/usr/bin/ruby -w
# coding: utf-8

Domotics::Setup.new do
  home
  kitchen
  bathroom
  wc
  hall
  
  # Room
  playroom do
    # Device
    arduino :nano_0, type: :nano do
      # Element
      light :corner_1_light, pin: 13
      light :corner_2_light, pin: 14
      light :corner_3_light, pin: 15
      light :corner_4_light, pin: 16
      rgb_strip :rgb_strip, r: 9, g: 10, b: 11
    end
  end
  living_room do
    arduino :nano_0 do
      light :center_light, pin: 13
    end
  end
end