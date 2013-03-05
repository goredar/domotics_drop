#!/usr/bin/ruby -w
# coding: utf-8

Dir[File.dirname(__FILE__) + '/app/**/*.rb'].sort.each {|file| require file}

srv = Domotics::DomServer.new
srv.start