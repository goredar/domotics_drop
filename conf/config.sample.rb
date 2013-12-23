home :home do
  kitchen :kt
  bathroom :bath
  wc :wc
  hall :hall

  # Room
  playroom :play do
    # Device
    arduino :nano_0, board: :nano do
      # Element
      switch :corner_1_light, pin: 13
      switch :corner_2_light, pin: 14
      switch :corner_3_light, pin: 15
      switch :corner_4_light, pin: 16
      rgb_strip :rgb_strip, r: 9, g: 10, b: 11
    end
  end
  living_room :live do
    arduino :nano_0 do
      switch :center_light, pin: 13
    end
  end
end