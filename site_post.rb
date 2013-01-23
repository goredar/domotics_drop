#!/usr/bin/ruby -w
# coding: utf-8
require 'net/http'
require 'uri'

while true do
  Net::HTTP.post_form URI('http://127.0.0.1/main/post_terminal_line'), { :terminal_line => $stdin.readline }
end