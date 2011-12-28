module Conformist
  class HashWithReaders
    extend Forwardable
    
    attr_accessor :attributes
    
    delegate [:[], :[]=, :fetch, :key?] => :attributes
    
    def initialize attributes = {}
      self.attributes = attributes
    end
    
    def merge other
      self.class.new.tap do |instance|
        instance.attributes = attributes.merge other
      end
    end
    
    def == other
      attributes == other.attributes
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
