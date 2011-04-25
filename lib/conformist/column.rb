module Conformist
  class Column
    attr_reader :name, :indexes, :preprocessor
    
    def initialize name, *indexes, &preprocessor
      @name, @indexes, @preprocessor = name, indexes, preprocessor
    end
    
    def values_in row
      values = indexes.map { |index| row[index].strip }
      values = values.first if values.size == 1
      if preprocessor.respond_to? :call
        preprocessor.call values
      else
        values
      end
    end
  end
end
