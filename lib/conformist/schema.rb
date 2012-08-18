module Conformist  
  module Schema
    def self.included base
      base.send :include, InstanceExtensions
      base.send :include, Methods
    end

    def self.extended base
      base.extend ClassExtensions
      base.extend Methods
    end

    module ClassExtensions
      def inherited base
        base.builder = builder.dup
        base.columns = columns.dup
      end

      def load *args
        raise "``#{self.class}.load` has been removed, use something like `#{self.class}.conform(file).each(&block)` instead (#{caller.first})"
      end
    end

    module InstanceExtensions
      def initialize super_schema = nil, &block
        if super_schema
          self.builder = super_schema.builder.dup
          self.columns = super_schema.columns.dup
        end
        if block
          instance_eval &block 
        end
      end
    end

    module Methods
      def builder
        @builder ||= Builder
      end

      def builder= value
        @builder = value
      end

      def column *args, &block
        args << columns.length if args.length == 1
        columns << Column.new(*args, &block)
      end

      def columns
        @columns ||= []
      end

      def columns= value
        @columns = value
      end

      def conform enumerables, options = {}
        options = options.dup
        Enumerator.new do |yielder|
          enumerables.each do |enumerable|
            next if options.delete :skip_first
            yielder.yield builder.call(self, enumerable)
          end
        end
      end
    end
  end
end
