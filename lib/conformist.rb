require 'csv'

require 'conformist/base'
require 'conformist/column'
require 'conformist/row'

module Conformist
  def self.foreach *bases, &block
    bases.each { |base| base.foreach(&block) }
  end
end
