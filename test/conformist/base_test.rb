require 'helper'

class BaseTest < MiniTest::Unit::TestCase
  class ACMA
    extend Base
    
    option :col_sep => ','
    option :quote_char => '"'

    column :name, 11 do |value| 
      value.match(/[A-Z\s\-]+$/)[0].upcase
    end
    column :callsign, 1
    column :latitude, 15
    column :signtal_type do 
      'digital'
    end
  end
  
  class FCC
    extend Base
    
    option :col_sep => '|'
     
    column :name, 10, 11 do |values|
      "#{values[0].upcase}, #{values[-1]}"
    end
    column :callsign, 1
    column :latitude, 20, 21, 22, 19 do |values|
      values.join(' ')
    end
    column :signtal_type do
      'digital'
    end
  end
  
  def test_file
    acma = [{:name => " CRAFERS", :callsign => "ABS2", :latitude => "34 58 49S", :signtal_type => "digital"}, {:name => " CRAFERS", :callsign => "SAS7", :latitude => "34 58 57S", :signtal_type => "digital"}, {:name => " CRAFERS", :callsign => "NWS9", :latitude => "34 59 02S", :signtal_type => "digital"}, {:name => " CRAFERS", :callsign => "ADS10", :latitude => "34 59 02S", :signtal_type => "digital"}, {:name => " CRAFERS", :callsign => "ADS10", :latitude => "34 58 57S", :signtal_type => "digital"}, {:name => " CRAFERS", :callsign => "SBS28", :latitude => "34 58 49S", :signtal_type => "digital"}, {:name => " CRAFERS", :callsign => "CTV31", :latitude => "34 58 49S", :signtal_type => "digital"}, {:name => " ADELAIDE", :callsign => "SBS43", :latitude => "34 55 34S", :signtal_type => "digital"}, {:name => " ADELAIDE", :callsign => "ABS46", :latitude => "34 55 34S", :signtal_type => "digital"}, {:name => " ADELAIDE", :callsign => "SAS49", :latitude => "34 55 34S", :signtal_type => "digital"}]
    ACMA.foreach fixture('acma.csv') do |row|
      assert_equal acma.shift, row
    end
    
    fcc = [{:name => "LOS ANGELES, CA", :callsign => "KVTU-LP", :latitude => "34 11 13.90 N", :signtal_type => "digital"}, {:name => "BAKERSFIELD, CA", :callsign => "NEW", :latitude => "35 12 6.00 N", :signtal_type => "digital"}, {:name => "YUCA VALLEY, CA", :callsign => "NEW", :latitude => "34 9 10.10 N", :signtal_type => "digital"}, {:name => "SACRAMENTO, CA", :callsign => "KCSO-LD", :latitude => "38 7 10.00 N", :signtal_type => "digital"}, {:name => "LOS ANGELES, CA", :callsign => "KVTU-LP", :latitude => "34 13 38.00 N", :signtal_type => "digital"}, {:name => "LOS ANGELES, CA", :callsign => "KVTU-LP", :latitude => "34 11 14.00 N", :signtal_type => "digital"}, {:name => "SACRAMENTO, CA", :callsign => "KCSO-LD", :latitude => "38 7 10.00 N", :signtal_type => "digital"}, {:name => "LOS ANGELES, CA", :callsign => "KVTU-LP", :latitude => "34 14 18.00 N", :signtal_type => "digital"}, {:name => "LOS ANGELES, CA", :callsign => "KVTU-LP", :latitude => "34 0 56.00 N", :signtal_type => "digital"}, {:name => "PETALUMA, CA", :callsign => "K14MW-D", :latitude => "37 45 19.00 N", :signtal_type => "digital"}]
    FCC.foreach fixture('fcc.txt') do |row|
      assert_equal fcc.shift, row
    end
  end
end
