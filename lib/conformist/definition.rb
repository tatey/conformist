module Conformist  
  class Definition
    extend Forwardable
    
    attr_accessor :columns, :conformer
    
    delegate [:[], :each, :size] => :columns
    
    def initialize &block
      self.columns   = []
      self.conformer = Row
      if block
        instance_eval &block 
      end
    end

    def column *args
      columns << Column.new(*args)
    end
    
    def conform rows
      Enumerator.new do |yielder|
        rows.each do |row|
          yielder.yield conformer.call(self, row)
        end
      end
    end
  end
end
