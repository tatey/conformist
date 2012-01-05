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
  
  def self.foreach *args, &block
    raise "`Conformist.foreach` has been removed, use something like `[MySchema1.conform(file1), MySchema2.conform(file2)].each(&block)` instead (#{caller.first})"
  end
  
  def self.new *args, &block
    Class.new { include Definition }.new *args, &block
  end
end
