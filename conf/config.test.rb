#!/usr/bin/ruby -w
# coding: utf-8

Domotics::Setup.new do
  home
  # Room
  test_room do
    # Device
    arduino :nano, type: :nano do
      # Element
      light :light_1, pin: 13
      dimmer :dimmer, pin: 3
      rgb_strip :rgb, r: 9, g: 10, b: 11
    end
  end
end