home :test_home do
  # Room
  test_room :test do
    # Device
    arduino :nano, board: :nano do
      # Element
      switch :light_1, pin: 13
      switch :light_2, pin: 13
      dimmer :dimmer, pin: 3
      rgb_strip :rgb, r: 9, g: 10, b: 11
    end
  end
end