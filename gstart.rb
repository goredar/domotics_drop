#!/usr/bin/ruby -w
# coding: utf-8

# Require subtree
Dir[File.dirname(__FILE__) + '/app/**/*.rb'].sort.each {|file| require file}
# Create logger
require 'logger'
$logger = Logger.new(STDERR)
$logger.level = Logger::DEBUG
$logger.formatter = proc do |severity, datetime, progname, msg|
  "#{severity}=> #{msg}"
end
# Run server
Domotics::DomServer.new.start