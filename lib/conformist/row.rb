module Conformist
  class Row
    attr_reader :columns, :row
    
    def initialize columns, row
      @columns, @row = columns, row
    end
    
    # Extracts key-value pairs for each column in the row. Will implicitly
    # join an array into a string.
    #
    # Example:
    #
    #   row = Row.new columns, csv_row
    #   row.to_hash # => {:first => 'Hello', :second => 'World'}
    #
    # Returns conformed hash.
    def to_hash
      columns.inject({}) do |attributes, column|
        values = column.values_in row
        values = values.join if values.respond_to? :join
        attributes.merge column.name => values
      end
    end
  end
end
