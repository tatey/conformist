module Conformist
  module Base
    def column name, *indexes, &preprocessor
      columns << Column.new(name, *indexes, &preprocessor)
    end

    def columns
      @columns ||= []
    end
    
    def options value = nil
      @options = value if value
      @options ||= {}
    end
    
    def foreach path, &block
      CSV.foreach(path, options) { |row| yield Row.new(columns, row).to_hash }
    end
  end
end
