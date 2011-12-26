module Conformist  
  class Definition
    extend Forwardable
    
    attr_accessor :columns
    
    delegate [:[], :size] => :columns
    
    def initialize &block
      self.columns = []
      if block
        instance_eval &block 
      end
    end

    def column *args
      columns << Column.new(*args)
    end
  end
end
