require 'conformist/base'
require 'conformist/builder'
require 'conformist/column'
require 'conformist/definition'
require 'conformist/hash_with_readers'

module Conformist
  unless defined? Enumerator # Compatible with 1.8
    require 'generator'
    Enumerator = Generator
  end
  
  def self.extended base
    base.extend Definition
  end
  
  def self.new *args, &block
    Class.new { include Definition }.new *args, &block
  end
end
