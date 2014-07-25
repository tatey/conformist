require 'forwardable'

require 'conformist/builder'
require 'conformist/column'
require 'conformist/hash_struct'
require 'conformist/schema'

module Conformist
  def self.extended base
    base.extend Schema
  end

  def self.new *args, &block
    Class.new { include Schema }.new *args, &block
  end
end
