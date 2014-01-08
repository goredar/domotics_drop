home :test_home do
  # Room
  test_room :test do
    # Device
    arduino :nano, board: :nano, port: $emul.port do
      # Element
      switch :light_1, pin: 13
      switch :light_2, pin: 13
      dimmer :dimmer, pin: 3
      rgb_strip :rgb, r: 9, g: 10, b: 11
      button :btn, pin: 7
    end
  end
end