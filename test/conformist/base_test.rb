require 'helper'

class BaseTest < MiniTest::Unit::TestCase
  def setup
    @klass = Class.new.tap { |klass| klass.send :include, Conformist::Base }
  end
  
  def test_option
    @klass.option :a => 1
    @klass.option :b => 2
    assert_equal({:a => 1, :b => 2}, @klass.options)
  end
  
  def test_column
    @klass.column :a, 0
    @klass.column :b, 1
    assert_equal 2, @klass.columns.size
    assert_instance_of Conformist::Column, @klass.columns.sample
  end
  
  def test_load
    instance = @klass.load 'file'
    assert_equal 'file', instance.path
    assert_instance_of @klass, instance
  end
  
  def test_foreach
    rows = [
      {:name => "CRAFERS", :callsign => "ABS2",  :latitude => "34 58 49S", :signtal_type => "digital"},
      {:name => "CRAFERS", :callsign => "SAS7",  :latitude => "34 58 57S", :signtal_type => "digital"},
      {:name => "CRAFERS", :callsign => "NWS9",  :latitude => "34 59 02S", :signtal_type => "digital"},
      {:name => "CRAFERS", :callsign => "ADS10", :latitude => "34 59 02S", :signtal_type => "digital"},
      {:name => "CRAFERS", :callsign => "ADS10", :latitude => "34 58 57S", :signtal_type => "digital"}
    ]
    ACMA.load(fixture('acma.csv')).foreach do |row|
      assert_equal rows.shift, row
    end
  end
end
