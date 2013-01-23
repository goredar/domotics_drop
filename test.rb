#!/usr/bin/ruby -w
# coding: utf-8

require 'socket'
TCPSocket.open('goredar.dyndns.org', 50002) do |socket|
  puts socket.gets
  5.times do
    socket.puts("pinstate 5 1")
    socket.puts("pinstate 5 0")
  end
  socket.puts("QUIT")
end