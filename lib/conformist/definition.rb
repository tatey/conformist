module Conformist  
  class Definition
    extend Forwardable
    
    attr_accessor :columns
    
    delegate [:[], :size] => :columns
    
    def initialize
      self.columns = []
    end

    def column *args
      columns << Column.new(*args)
    end
  end
end
