#!/usr/bin/ruby -w
# coding: utf-8

Dir[File.dirname(__FILE__) + '/app/**/*.rb'].sort.each {|file| require file}

srv = Domotics::Server.new

5.times do
  Domotics::Room[:wc].lights.on
  sleep 1
  Domotics::Room[:wc].lights.off
  sleep 1
end

srv.run
