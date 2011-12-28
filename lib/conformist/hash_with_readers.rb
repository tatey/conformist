module Conformist
  class HashWithReaders
    extend Forwardable
    
    attr_accessor :attributes
    
    delegate [:[], :[]=] => :attributes
    
    def initialize attributes = {}
      self.attributes = attributes
    end
    
    def merge other
      self.class.new.tap do |instance|
        instance.attributes = attributes.merge other
      end
    end
    
  protected
  
    def respond_to_missing? method, include_private
      attributes.key?(method) || super
    end
    
    def method_missing method, *args, &block
      attributes.fetch method, super
    end
  end
end
