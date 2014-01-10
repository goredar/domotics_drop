home :test_home do
  test_room :test do
    button :button_no_dev
    dimmer :dimmer_no_dev
    motion_sensor :ms_no_dev
    reed_switch :rs_no_dev
    rgb_strip :rgb_no_dev
    switch :light_no_dev
    arduino :nano, board: :nano, port: $emul.port do
      button :button, pin: 6
      dimmer :dimmer, pin: 3
      motion_sensor :ms, pin: 7
      reed_switch :rs, pin: 8
      rgb_strip :rgb, r: 9, g: 10, b: 11
      switch :light_1, pin: 13
    end
  end
end