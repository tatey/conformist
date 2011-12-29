module Conformist
  module Base
    def self.included base
      raise "Conformist::Base is deprecated, extend Conformist instead (#{caller.first})"
    end
  end  
end
