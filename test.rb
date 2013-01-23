#!/usr/bin/ruby -w
# coding: utf-8

require 'socket'
TCPSocket.open('goredar.dyndns.org', 50002) do |socet|
  puts socket.gets
  5.times do
    socet.puts("pinstate 5 1")
    sleep 0.1
    socet.puts("pinstate 5 0")
    sleep 0.1
  end
  socet.puts("QUIT")
end