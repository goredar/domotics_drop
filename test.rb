#!/usr/bin/ruby -w
# coding: utf-8

require 'socket'
TCPSocket.open('goredar.dyndns.org', 50002) do |socket|
  p eval socket.gets
  5.times do
    socket.puts '{request: :test}'
    p eval socket.gets
  end
  socket.puts("QUIT")
end