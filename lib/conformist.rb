require 'forwardable'

require 'conformist/builder'
require 'conformist/column'
require 'conformist/hash_struct'
require 'conformist/schema'

module Conformist
  unless defined? Enumerator # Compatible with 1.8
    require 'generator'
    Enumerator = Generator
  end

  def self.extended base
    base.extend Schema
  end

  def self.new *args, &block
    Class.new { include Schema }.new *args, &block
  end
end
