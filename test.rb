#!/usr/bin/ruby -w
# coding: utf-8

require 'socket'
TCPSocket.open('goredar.dyndns.org', 50002) do |socket|
  5.times do
    socket.puts request: :test
    socket.recv(0)
    p socket.gets
    sleep 5
  end
  socket.puts request: :quit
end