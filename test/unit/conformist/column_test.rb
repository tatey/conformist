require 'helper'

class Conformist::ColumnTest < MiniTest::Unit::TestCase
  def stub_row
    ('a'..'d').to_a
  end

  def test_name
    column = Column.new :foo
    assert_equal :foo, column.name
  end

  def test_one_index
    column = Column.new :foo, 0
    assert_equal 'a', column.values_in(stub_row)
  end

  def test_preprocess_with_one_index
    column = Column.new(:foo, 0) { |value| value.upcase }
    assert_equal 'A', column.values_in(stub_row)
  end

  def test_many_indexes
    column = Column.new :foo, 1, 2, 3
    assert_equal ['b', 'c', 'd'], column.values_in(stub_row)
  end

  def test_preprocess_with_many_indexes
    column = Column.new(:foo, 1, 2, 3) { |values| values.reverse }
    assert_equal ['d', 'c', 'b'], column.values_in(stub_row)
  end

  def test_virtual
    column = Column.new(:foo) { 'a' }
    assert_equal 'a', column.values_in(stub_row)
  end

  def test_strip_whitespace
    column = Column.new :foo, 0
    assert_equal 'a', column.values_in(['  a  '])
  end

  def test_array
    mock   = MiniTest::Mock.new
    mock.expect :[], 0, ['a']
    mock.expect :to_a, ['a']
    column = Column.new :foo, 0
    assert_equal 'a', column.values_in(['a'])
    assert_equal 'a', column.values_in('a')
    assert_equal 'a', column.values_in(mock)
  end

  def test_nil
    column = Column.new :foo, 0
    assert_nil column.values_in([])
  end

  def stub_hash_row
    {'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4}
  end

  def stub_struct_row
    OpenStruct.new({'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4})
  end

  def test_named_source_columns_with_hash
    column = Column.new(:foo, 'a')
    assert_equal 1, column.values_in(stub_hash_row)
  end

  def test_named_source_columns_with_struct
    column = Column.new(:foo, 'a')
    assert_equal 1, column.values_in(stub_struct_row)
  end

  def test_values_in_object
    column = Column.new(:foo, 'a')
    assert_equal 1, column.values_in_object(stub_hash_row)
  end

  def test_values_in_arraylike_object
    column = Column.new(:foo, 0)
    assert_equal 'a', column.values_in_arraylike_object(stub_row)
  end 

  def test_values_in_hashlike_object
    column = Column.new(:foo, 'a')
    assert_equal 1, column.values_in_hashlike_object(stub_hash_row)
  end 

  def test_values_in_structlike_object
    column = Column.new(:foo, 'a')
    assert_equal 1, column.values_in_structlike_object(stub_struct_row)
  end 

end
