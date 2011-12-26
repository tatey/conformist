if RUBY_VERSION >= '1.9.0'
  require 'csv'
else
  require 'fastercsv'
end

require 'conformist/base'
require 'conformist/column'
require 'conformist/definition'
require 'conformist/row'

module Conformist
  CSV = RUBY_VERSION >= '1.9.0' ? ::CSV : FasterCSV
  
  # Enumerate over each row from multiple input files.
  #
  # Example:
  #
  #   Conformist::Base.foreach Input1.load('input.csv'), Input2.load('input.csv') do |row|
  #     Model.create! row
  #   end
  #
  # Returns nothing.
  def self.foreach *bases, &block
    bases.each { |base| base.foreach(&block) }
  end
end
