require 'helper'

class BaseTest < MiniTest::Unit::TestCase
  def setup
    @class = Class.new.tap { |klass| klass.send :include, Conformist::Base }
  end
  
  def test_option
    @class.option :a => 1
    @class.option :b => 2
    assert_equal({:a => 1, :b => 2}, @class.options)
  end
  
  def test_column
    @class.column :a, 0
    @class.column :b, 1
    assert_equal 2, @class.columns.size
    assert_instance_of Conformist::Column, @class.columns[rand(2)]
  end
  
  def test_columns_inherit_from_superclass
    subclass = Class.new @class
    @class.column :a, 0
    @class.column :b, 1
    assert_equal @class.columns, subclass.columns
    subclass.column :c, 2
    subclass.column :d, 3
    refute_equal @class.columns, subclass.columns
  end
  
  def test_load
    instance = @class.load 'file'
    assert_equal 'file', instance.path
    assert_instance_of @class, instance
  end
  
  def test_foreach
    rows = [
      {:name => "CRAFERS", :callsign => "ABS2",  :latitude => "34 58 49S"},
      {:name => "CRAFERS", :callsign => "SAS7",  :latitude => "34 58 57S"},
      {:name => "CRAFERS", :callsign => "NWS9",  :latitude => "34 59 02S"},
      {:name => "CRAFERS", :callsign => "ADS10", :latitude => "34 59 02S"},
      {:name => "CRAFERS", :callsign => "ADS10", :latitude => "34 58 57S"}
    ]
    ACMA.load(fixture('acma.csv')).foreach do |row|
      assert_equal rows.shift, row
    end
  end
end
