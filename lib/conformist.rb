if RUBY_VERSION < '1.9'
  require 'generator'
end

require 'conformist/base'
require 'conformist/builder'
require 'conformist/column'
require 'conformist/definition'
require 'conformist/hash_with_readers'

module Conformist
  Enumerator = RUBY_VERSION < '1.9' ? Generator : ::Enumerator
  
  def self.extended base
    base.extend Definition
  end
  
  def self.new *args, &block
    Class.new { include Definition }.new *args, &block
  end
end
