#!/usr/bin/ruby -w
# coding: utf-8

# Water Closet
class WC < Room
  def analize(element)
    case element.state
    when :move
      light.on if door.close?
    when :nomove
      nil
    when :open
      lights.on 30
    when :close
      lights.delay_off 10
    else
      nil
    end
  end
end