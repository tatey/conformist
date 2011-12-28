module Conformist  
  class Definition
    extend Forwardable
    
    attr_accessor :builder, :columns
    
    def initialize definition = nil, &block
      self.builder = definition ? definition.builder.dup : Builder
      self.columns = definition ? definition.columns.dup : []
      if block
        instance_eval &block 
      end
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
