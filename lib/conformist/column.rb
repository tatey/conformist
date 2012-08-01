module Conformist
  class Column
    attr_accessor :name, :indexes, :preprocessor
        
    def initialize name, *indexes, &preprocessor
      self.name         = name
      self.indexes      = indexes
      self.preprocessor = preprocessor
    end
    
    def values_in enumerable
      values = Array(enumerable).values_at(*indexes).map do |value|
        value = value.last if value.is_a? Array
        if value.respond_to? :strip
          value.strip
        else
          value
        end
      end    
      values = values.first if values.size == 1  
      if preprocessor
        preprocessor.call values
      else
        values
      end
    end
  end
end
