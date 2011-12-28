module Conformist  
  module Definition
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
