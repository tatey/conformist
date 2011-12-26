module Conformist  
  class Definition
    attr_accessor :columns
    
    def initialize
      self.columns = []
    end
  end
end
