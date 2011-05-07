module Conformist
  module Base
    def self.included base
      base.class_eval do
        extend ClassMethods
        attr_accessor :path
      end
    end

    # Enumerate over each row in the input file.
    #
    # Example:
    #
    #   input1 = Input1.load 'input1.csv'
    #   input1.foreach do |row|
    #     Model.create! row
    #   end
    #
    # Returns nothing.
    def foreach &block
      CSV.foreach(path, self.class.options) do |row| 
        yield Row.new(self.class.columns, row).to_hash
      end
    end
    
    module ClassMethods      
      def column name, *indexes, &preprocessor
        columns << Column.new(name, *indexes, &preprocessor)
      end

      def columns
        @columns ||= if superclass.ancestors.include? Conformist::Base
          superclass.columns.dup
        else
          []
        end
      end

      def option value
        options.merge! value
      end

      def options
        @options ||= {}
      end
            
      def load path
        new.tap { |object| object.path = path }
      end
    end
  end
end
