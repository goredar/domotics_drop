class Domo
  RUBY_HASH_REGEXP = /\A([a-z]\w*: (\d+|:\w+|'(\/\w+)+')(, )?)+\Z/
  RUBY_CLASS_REGEXP = /\A[A-Z]+\w*(::)?[A-Z]+\w*\Z/
  RUBY_NAME_REGEXP = /\A[a-z]\w*\Z/
  WORDS_REGEXP = /\A[\w ]+\Z/
end