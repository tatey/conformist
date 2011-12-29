require 'csv'
require 'definitions/acma'
require 'definitions/fcc'
require 'helper'

class IntegrationTest < MiniTest::Unit::TestCase
  def fixture filename
    File.expand_path "../../fixtures/#{filename}", __FILE__
  end
  
  def csv filename, options = {}
    if RUBY_VERSION < '1.9'
      CSV.open fixture(filename), 'r', options[:col_sep]
    else
      CSV.open fixture(filename), options
    end
  end

  def test_class_with_csv
    enumerable = ACMA.conform csv('acma.csv')
    last       = enumerable.to_a.last
    assert_equal HashWithReaders.new(:name=>'CRAFERS', :callsign=>'ADS10', :latitude=>'34 58 57S'), last
  end
  
  def test_inherited_class_with_csv
    enumerable = ACMA::Digital.conform csv('acma.csv')
    last       = enumerable.to_a.last
    assert_equal HashWithReaders.new(:name=>'CRAFERS', :callsign=>'ADS10', :latitude=>'34 58 57S', :signal_type => 'digital'), last
  end
  
  def test_class_with_psv
    enumerable = FCC.conform csv('fcc.txt', :col_sep => '|')
    last       = enumerable.to_a.last
    assert_equal HashWithReaders.new(:name => 'LOS ANGELES, CA', :callsign => 'KVTU-LP', :latitude => '34 13 38.00 N', :signtal_type => 'digital'), last
  end
  
  def test_instance_with_array_of_arrays
    data = Array.new.tap do |d|
      d << ['NSW', 'New South Wales', 'Sydney']
      d << ['VIC', 'Victoria', 'Melbourne']
      d << ['QLD', 'Queensland', 'Brisbane']
    end
    definition = Conformist.new do
      column :state, 0, 1 do |values|
        "#{values.first}, #{values.last}"
      end
      column :capital, 2
    end
    enumerable = definition.conform data
    last = enumerable.to_a.last
    assert_equal HashWithReaders.new(:state => 'QLD, Queensland', :capital => 'Brisbane'), last
  end
  
  def test_inherited_instance_with_array_of_arrays
    data = Array.new.tap do |d|
      d << ['NSW', 'New South Wales', 'Sydney']
      d << ['VIC', 'Victoria', 'Melbourne']
      d << ['QLD', 'Queensland', 'Brisbane']
    end
    parent = Conformist.new do
      column :state, 0, 1 do |values|
        "#{values.first}, #{values.last}"
      end
      column :capital, 2
    end
    child = Conformist.new parent do
      column :country do 
        'Australia'
      end
    end
    enumerable = child.conform data
    last = enumerable.to_a.last
    assert_equal HashWithReaders.new(:state => 'QLD, Queensland', :capital => 'Brisbane', :country => 'Australia'), last
  end
end
