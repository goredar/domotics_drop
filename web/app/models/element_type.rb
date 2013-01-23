class ElementType < ActiveRecord::Base
  has_many :elements

  before_destroy { |x| x.elements.empty? }

  attr_accessible :class_name, :description, :name, :options

  validates :name, :presence => true, :uniqueness => true
  validates :class_name, :presence => true, :format => { :with => GHome::WORD_REGEXP }
  validates :options, :format => { :with => GHome::HASH_REGEXP }, :if => lambda { |x| !x.options.empty? }
end
