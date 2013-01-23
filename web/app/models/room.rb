class Room < ActiveRecord::Base
  belongs_to :room_type
  has_many :elements

  before_destroy { |x| x.elements.empty? }

  attr_accessible :description, :name, :options, :room_type_id

  validates :name, :presence => true, :uniqueness => true, :format => { :with => GHome::WORD_REGEXP }
  validates :room_type_id, :presence => true, :inclusion => {:in => proc { RoomType.all.collect{|x| x.id }}}
  validates :options, :format => { :with => GHome::HASH_REGEXP }, :if => lambda { |x| !x.options.empty? }
end