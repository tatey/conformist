module Conformist
  module Base
    def self.included klass
      klass.class_eval do
        extend ClassMethods
        attr_accessor :path
      end
    end
    
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
        @columns ||= []
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
