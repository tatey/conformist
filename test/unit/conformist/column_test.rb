require 'helper'

class ColumnTest < MiniTest::Unit::TestCase
  def stub_row
    ('a'..'d').to_a
  end
  
  def test_name
    column = Conformist::Column.new :foo
    assert_equal :foo, column.name
  end
  
  def test_one_index
    column = Conformist::Column.new :foo, 0
    assert_equal 'a', column.values_in(stub_row)
  end
  
  def test_preprocess_with_one_index
    column = Conformist::Column.new(:foo, 0) { |value| value.upcase }
    assert_equal 'A', column.values_in(stub_row)
  end
  
  def test_many_indexes
    column = Conformist::Column.new :foo, 1, 2, 3
    assert_equal ['b', 'c', 'd'], column.values_in(stub_row)
  end
  
  def test_preprocess_with_many_indexes
    column = Conformist::Column.new(:foo, 1, 2, 3) { |values| values.reverse }
    assert_equal ['d', 'c', 'b'], column.values_in(stub_row)
  end
  
  def test_virtual
    column = Conformist::Column.new(:foo) { 'a' }
    assert_equal 'a', column.values_in(stub_row)
  end
  
  def test_strip_whitespace
    column = Conformist::Column.new(:foo, 0)
    assert_equal 'a', column.values_in(['  a  '])
  end
  
  def test_nil
    column = Conformist::Column.new(:foo, 0)
    assert_nil column.values_in([])
  end
end
