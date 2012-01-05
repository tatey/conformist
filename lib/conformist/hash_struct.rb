module Conformist
  class HashStruct
    extend Forwardable
    
    attr_accessor :attributes
        
    def_delegators :attributes, :[], :[]=, :fetch, :key?
    
    def initialize attributes = {}
      self.attributes = attributes
    end
    
    def merge other
      self.class.new.tap do |instance|
        instance.attributes = attributes.merge other
      end
    end
    
    def == other
      other.class == self.class && attributes == other.attributes
    end
    
  protected
  
    def respond_to_missing? method, include_private
      key?(method) || super
    end
    
    def method_missing method, *args, &block
      fetch(method) { super }
    end
  end
end
