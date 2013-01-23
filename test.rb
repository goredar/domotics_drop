#!/usr/bin/ruby -w
# coding: utf-8

require 'socket'
TCPSocket.open('goredar.dyndns.org', 50002) do |socket|
  puts socket.gets
  5.times do
    socket.puts("SET wc.lights.on")
    socket.puts("SET wc.lights.off")
  end
  socket.puts("QUIT")
end