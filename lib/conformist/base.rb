module Conformist
  module Base
    def self.included base
      raise "`include Conformist::Base` has been removed, `extend Conformist` instead (#{caller.first})"
    end
  end
end
