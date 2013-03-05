class ElementType < ActiveRecord::Base
  has_many :elements

  before_destroy { |x| x.elements.empty? }

  attr_accessible :class_name, :description, :name, :options

  validates :name, :presence => true, :uniqueness => true, :format => { :with => Domo::WORDS_REGEXP }
  validates :class_name, :presence => true, :format => { :with => Domo::RUBY_CLASS_REGEXP }
  validates :options, :format => { :with => Domo::RUBY_HASH_REGEXP }, :if => lambda { |x| !x.options.empty? }
end
