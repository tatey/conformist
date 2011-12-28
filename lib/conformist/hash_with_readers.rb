module Conformist
  class HashWithReaders
    extend Forwardable
    
    attr_accessor :attributes
    
    delegate [:[], :[]=] => :attributes
    
    def initialize
      self.attributes = {}
    end
    
    def merge other
      self.class.new.tap do |instance|
        instance.attributes = attributes.merge other
      end
    end
    
  protected
  
    def respond_to_missing? method, include_private
      attributes.has_key?(method) || super
    end
    
    def method_missing method, *args, &block
      if attributes.has_key? method
        attributes[method]
      else
        super
      end
    end
  end
end
