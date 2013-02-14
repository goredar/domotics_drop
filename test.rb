#!/usr/bin/ruby -w
# coding: utf-8

require 'socket'
TCPSocket.open('goredar.dyndns.org', 50002) do |socket|
  puts Marshal.load socket.gets.chop
  5.times do
    socket.puts Marshal.dump request: :test
    p Marshal.load socket.gets.chop
  end
  socket.puts("QUIT")
end