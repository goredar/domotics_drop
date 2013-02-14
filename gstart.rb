#!/usr/bin/ruby -w
# coding: utf-8

Dir[File.dirname(__FILE__) + '/app/**/*.rb'].sort.each {|file| require file}

srv = Domotics::DomServer.new
srv.start

5.times do
  p 'on'
  Domotics::Room[:wc].lights.on 3
  sleep 3
  p 'off'
  sleep 1
end

5.times do
  p '3 sec to on'
  Domotics::Room[:wc].lights.delay_on 3
  sleep 3
  p 'on'
  sleep 1
  p '3 sec to off'
  Domotics::Room[:wc].lights.delay_off 3
  sleep 3
  p 'off'
  sleep 1
end
