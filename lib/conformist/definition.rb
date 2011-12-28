module Conformist  
  class Definition
    extend Forwardable
    
    attr_accessor :builder, :columns
    
    def initialize definition = nil, &block
      if definition
        self.builder = definition.builder.dup
        self.columns = definition.columns.dup
      else
        self.builder = Builder
        self.columns = []
      end
      instance_eval &block if block
    end

    def column *args
      columns << Column.new(*args)
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
