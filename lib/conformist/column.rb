module Conformist
  class Column
    attr_reader :name, :indexes, :preprocessor
        
    def initialize name, *indexes, &preprocessor
      @name, @indexes, @preprocessor = name, indexes, preprocessor
    end
    
    # Map column(s) into a single value, strips whitespace and performs
    # any preprocessing. Takes a +row+ argument that should behave as an
    # array-like object.
    #
    # Example:
    #
    #   row    = ['Hello', 'World']
    #   column = Column.new :first, 0
    #   column.value_in row # => 'Hello'
    #
    # Returns preprocessed value.
    def values_in row      
      values = indexes.map { |index| row[index] ? row[index].strip : nil }
      values = values.first if values.size == 1
      if preprocessor.respond_to? :call
        preprocessor.call values
      else
        values
      end
    end
  end
end
