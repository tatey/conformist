require 'helper'

class ConformistTest < MiniTest::Unit::TestCase
  def test_foreach
    rows = [
      {:name => "CRAFERS",         :callsign => "ABS2",    :latitude => "34 58 49S",     :signtal_type => "digital"},
      {:name => "CRAFERS",         :callsign => "SAS7",    :latitude => "34 58 57S",     :signtal_type => "digital"},
      {:name => "CRAFERS",         :callsign => "NWS9",    :latitude => "34 59 02S",     :signtal_type => "digital"},
      {:name => "CRAFERS",         :callsign => "ADS10",   :latitude => "34 59 02S",     :signtal_type => "digital"},
      {:name => "CRAFERS",         :callsign => "ADS10",   :latitude => "34 58 57S",     :signtal_type => "digital"},
      {:name => "LOS ANGELES, CA", :callsign => "KVTU-LP", :latitude => "34 11 13.90 N", :signtal_type => "digital"},
      {:name => "BAKERSFIELD, CA", :callsign => "NEW",     :latitude => "35 12 6.00 N",  :signtal_type => "digital"},
      {:name => "YUCA VALLEY, CA", :callsign => "NEW",     :latitude => "34 9 10.10 N",  :signtal_type => "digital"},
      {:name => "SACRAMENTO, CA",  :callsign => "KCSO-LD", :latitude => "38 7 10.00 N",  :signtal_type => "digital"},
      {:name => "LOS ANGELES, CA", :callsign => "KVTU-LP", :latitude => "34 13 38.00 N", :signtal_type => "digital"}
    ]
    Conformist.foreach ACMA.load(fixture('acma.csv')), FCC.load(fixture('fcc.txt')) do |row|
      assert_equal rows.shift, row
    end
  end
end
