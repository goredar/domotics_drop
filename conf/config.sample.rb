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
      group :corner_light do
        group :door_side_light do
          switch :corner_1_light, pin: 13
          switch :corner_3_light, pin: 15
        end
        group :window_side_light do
          switch :corner_2_light, pin: 14
          switch :corner_4_light, pin: 16
        end
      end
      switch :center_light, pin: 17
      rgb_strip :rgb_strip, r: 9, g: 10, b: 11
    end
  end
  living_room :live do
    arduino :nano_0 do
      group :center_light do
        switch :door_side_light, pin: 13
        switch :window_side_light, pin: 14
      end
      group :board_light do
        group :long_side_light do
          switch :board_2_light, pin: 16
          switch :board_4_light, pin: 18
        end
        group :short_side_light do
          switch :board_1_light, pin: 15
          switch :board_3_light, pin: 17
        end
      end
    end
  end
end