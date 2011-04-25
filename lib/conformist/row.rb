module Conformist
  class Row
    attr_reader :columns, :row
    
    def initialize columns, row
      @columns, @row = columns, row
    end
    
    def to_hash
      columns.inject({}) do |attributes, column|
        values = column.values_in row
        values = values.join if values.respond_to? :join
        attributes.merge(column.name => values)
      end
    end
  end
end
