module Conformist  
  module Definition
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
    end
    
    module InstanceExtensions
      def initialize instance = nil, &block
        if instance
          self.builder = instance.builder.dup
          self.columns = instance.columns.dup
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

      def column *args
        columns << Column.new(*args)
      end

      def columns
        @columns ||= []
      end

      def columns= value
        @columns = value
      end

      def conform enumerables
        Enumerator.new do |yielder|
          enumerables.each do |enumerable|
            yielder.yield builder.call(self, enumerable)
          end
        end
      end
    end
  end
end
