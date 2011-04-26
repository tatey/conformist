module Conformist
  module Base
    def column name, *indexes, &preprocessor
      columns << Column.new(name, *indexes, &preprocessor)
    end

    def columns
      @columns ||= []
    end
    
    def option value
      options.merge! value
    end
    
    def options
      @options ||= {}
    end
            
    def foreach path, &block
      CSV.foreach(path, options) { |row| yield Row.new(columns, row).to_hash }
    end
  end
end
