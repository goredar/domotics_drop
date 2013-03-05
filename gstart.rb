#!/usr/bin/ruby -w
# coding: utf-8

# Require subtree
Dir[File.dirname(__FILE__) + '/app/**/*.rb'].sort.each {|file| require file}
# Create logger
logger = Logger.new(STDERR)
logger.level = Logger::WARN
# Run server
Domotics::DomServer.new.start