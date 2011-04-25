require 'helper'

class BaseTest < MiniTest::Unit::TestCase
  class ACMA
    extend Conformist::Base
    
    options :col_sep => ',', :quote_char => '"'

    column :name, 11 do |value| 
      value.match(/[A-Z\s\-]+$/)[0].upcase
    end
    column :callsign, 1
    column :latitude, 15
  end
  
  class FCC
    extend Conformist::Base
    
    options :col_sep => '|'
     
    column :name, 10, 11 do |values|
      "#{values[0].titlecase}, #{values[-1]}"
    end
    column :callsign, 1
    column :latitude, 20, 21, 22, 19 do |values|
      values.join(' ')
    end
  end
end
