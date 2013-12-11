#!/usr/bin/ruby -w
# coding: utf-8

Domotics::Setup.new do
  home :test_home
  # Room
  test_room :test do
    # Device
    arduino :nano, board: :nano do
      # Element
      light :light_1, pin: 13
      light :light_2, pin: 13
      dimmer :dimmer, pin: 3
      rgb_strip :rgb, r: 9, g: 10, b: 11
    end
  end
end