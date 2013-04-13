class Element < ActiveRecord::Base
  belongs_to :element_type
  belongs_to :device
  belongs_to :room

  attr_accessible :description, :device_id, :element_type_id, :name, :options, :room_id

  validates :name, :element_type_id, :room_id, :device_id, :options, :presence => true
  validates :name, :format => { :with => Domo::RUBY_NAME_REGEXP }
  validates :element_type_id, :inclusion => {:in => proc { ElementType.all.collect{|x| x.id }}}
  validates :room_id, :inclusion => {:in => proc { Room.all.collect{|x| x.id }}}
  validates :device_id, :inclusion => {:in => proc { Device.all.collect{|x| x.id }}}
  validates :options, :format => { :with => Domo::RUBY_HASH_REGEXP }

  scope :by_room, order(:room_id, :name)
end
