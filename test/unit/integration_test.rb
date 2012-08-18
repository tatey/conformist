require 'csv'
require 'helper'
require 'schemas/acma'
require 'schemas/citizens'
require 'schemas/fcc'
require 'spreadsheet'

class IntegrationTest < MiniTest::Unit::TestCase
  def fixture filename
    File.expand_path "../../fixtures/#{filename}", __FILE__
  end

  def open_csv filename, options = {}
    if CSV.method(:open).arity == -3 # 1.8 CSV
      CSV.open fixture(filename), 'r', options[:col_sep]
    else
      CSV.open fixture(filename), options
    end
  end

  def test_class_with_csv
    enumerable = ACMA.conform open_csv('acma.csv')
    last       = enumerable.to_a.last
    assert_equal HashStruct.new(:name=>'CRAFERS', :callsign=>'ADS10', :latitude=>'34 58 57S'), last
  end

  def test_class_with_csv_including_headers
    enumerable = Citizens.conform open_csv('citizens.csv'), :skip_first => true
    first      = enumerable.to_a.first
    assert_equal HashStruct.new(:name => 'Aaron', :age => '21', :gender => 'Male'), first
  end
  
  def test_inherited_class_with_csv
    enumerable = ACMA::Digital.conform open_csv('acma.csv')
    last       = enumerable.to_a.last
    assert_equal HashStruct.new(:name=>'CRAFERS', :callsign=>'ADS10', :latitude=>'34 58 57S', :signal_type => 'digital'), last
  end
  
  def test_class_with_psv
    enumerable = FCC.conform open_csv('fcc.txt', :col_sep => '|')
    last       = enumerable.to_a.last
    assert_equal HashStruct.new(:name => 'LOS ANGELES, CA', :callsign => 'KVTU-LP', :latitude => '34 13 38.00 N', :signtal_type => 'digital'), last
  end
  
  def test_instance_with_spreadsheet
    book       = Spreadsheet.open fixture('states.xls')
    sheet      = book.worksheet 0
    schema     = Conformist.new { column :state, 0 }
    enumerable = schema.conform sheet
    last       = enumerable.to_a.last
    assert_equal HashStruct.new(:state => 'QLD'), last
  end
  
  def test_instance_with_array_of_arrays
    data = Array.new.tap do |d|
      d << ['NSW', 'New South Wales', 'Sydney']
      d << ['VIC', 'Victoria', 'Melbourne']
      d << ['QLD', 'Queensland', 'Brisbane']
    end
    schema = Conformist.new do
      column :state, 0, 1 do |values|
        "#{values.first}, #{values.last}"
      end
      column :capital, 2
    end
    enumerable = schema.conform data
    last = enumerable.to_a.last
    assert_equal HashStruct.new(:state => 'QLD, Queensland', :capital => 'Brisbane'), last
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
    assert_equal HashStruct.new(:state => 'QLD, Queensland', :capital => 'Brisbane', :country => 'Australia'), last
  end
end
