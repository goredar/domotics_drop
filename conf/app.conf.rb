Domotics::Core::Setup.logger = Logger.new(STDERR)
Domotics::Core::Setup.logger.level = Logger::DEBUG
#Domotics::Core::Setup.logger.formatter = proc do |severity, datetime, progname, msg|
#  "#{severity} #{msg}#{$/}"
#end
Domotics::Core::Element.data = Domotics::Core::DataRedis.new