require 'conformist/definition'
require 'conformist/anonymous'
require 'conformist/builder'
require 'conformist/column'
require 'conformist/hash_with_readers'

module Conformist
  def self.included base
    base.extend Definition
  end
  
  def self.new *args, &block
    Anonymous.new *args, &block
  end
end
