require 'helper'

class Conformist::ColumnTest < MiniTest::Unit::TestCase
  def stub_row
    ('a'..'d').to_a
  end

  def stub_hash_row
    {'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4}
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

  def test_arraylike_object
    mock_a = MiniTest::Mock.new
    mock_a.expect :[], 'a', [0]
    mock_a.expect :to_a, ['a', 'b']
    column = Column.new :foo, 0
    assert_equal 'a', column.values_in(['a', 'b'])
    assert_equal 'a', column.values_in('a')
    assert_equal 'a', column.values_in(mock_a)
  end

  def test_hashlike_object
    mock_h = MiniTest::Mock.new
    mock_h.expect :to_a, [['a', 1], ['b', 2]]
    mock_h.expect :[], 1, ['a']
    column = Column.new :foo, 'a'
    assert_equal 1, column.values_in({'a' => 1, 'b' => 2})
    assert_equal 1, column.values_in(mock_h)
  end

  def test_associative_arraylike_object # such as CSV::Row when to_a() is applied to it.  
    mock_aa = MiniTest::Mock.new
    mock_aa.expect :to_a, [['a', 1], ['b', 2]]
    mock_aa.expect :detect, ['a', 1], [['a', 1], ['b', 2]]
    column = Column.new :foo, 'a'
    assert_equal 1, column.values_in([['a', 1]])
    assert_equal 1, column.values_in(mock_aa)
  end

  def test_nil
    column = Column.new :foo, 0
    assert_nil column.values_in([])
  end

  def test_named_source_columns_with_hash
    column = Column.new(:foo, 'a')
    assert_equal 1, column.values_in(stub_hash_row)
  end

end
