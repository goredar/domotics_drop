#!/usr/bin/ruby -w
# coding: utf-8

Dir[File.dirname(__FILE__) + '/app/**/*.rb'].sort.each {|file| require file}

srv = Domotics::Server.new

5.times do
  Domotics::Room[:wc].lights.on 3
  sleep 4
end

5.times do
  Domotics::Room[:wc].lights.delay_on 3
  sleep 4
  Domotics::Room[:wc].lights.delay_off 3
  sleep 4
end


srv.run
