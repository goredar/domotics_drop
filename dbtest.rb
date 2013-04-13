#!/usr/bin/ruby
# coding: utf-8

require 'active_record'
require 'yaml'

dbconfig = YAML::load IO.read 'web/config/database.yml'
ActiveRecord::Base.establish_connection dbconfig["production"]

class ADevice < ActiveRecord::Base
  self.table_name = 'devices'
  belongs_to :device_type
end
class DeviceType < ActiveRecord::Base
end
class AElement < ActiveRecord::Base
  self.table_name = "elements"
  belongs_to :element_type
  belongs_to :device, :class_name => "ADevice"
  belongs_to :room, :class_name => "ARoom"
end
class ElementType < ActiveRecord::Base
end
class ARoom < ActiveRecord::Base
  self.table_name = "rooms"
  belongs_to :room_type
end
class RoomType < ActiveRecord::Base
end

AElement.all.each do |element|
  p element.room.name.to_sym
end