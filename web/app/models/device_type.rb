class DeviceType < ActiveRecord::Base
  has_many :devices

  before_destroy { |x| x.devices.empty? }

  attr_accessible :name, :class_name, :options, :description

  validates :name, :presence => true, :uniqueness => true, :format => { :with => Domo::WORDS_REGEXP }
  validates :class_name, :presence => true, :format => { :with => Domo::RUBY_CLASS_REGEXP }
  validates :options, :format => { :with => Domo::RUBY_HASH_REGEXP }, :if => lambda { |x| !x.options.empty? }
end