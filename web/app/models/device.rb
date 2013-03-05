class Device < ActiveRecord::Base
  belongs_to :device_type
  has_many :elements

  before_destroy { |x| x.elements.empty? }

  attr_accessible :device_type_id, :name, :options, :description

  validates :name, :presence => true, :uniqueness => true, :format => { :with => Domo::RUBY_NAME_REGEXP }
  validates :device_type_id, :presence => true, :inclusion => {:in => proc { DeviceType.all.collect{|x| x.id }}}
  validates :options, :format => { :with => Domo::RUBY_HASH_REGEXP }, :if => lambda { |x| !x.options.empty? }
end