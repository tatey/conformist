module Conformist
  class Anonymous
    include Definition
    
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
end
