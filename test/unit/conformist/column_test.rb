require 'helper'

class Conformist::ColumnTest < Minitest::Test
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
    column = Column.new :foo, 0
    assert_equal 'a', column.values_in(['a'])
    assert_equal 'a', column.values_in('a')
  end

  def test_nil
    column = Column.new :foo, 0
    assert_nil column.values_in([])
  end

  def test_passes_context
    context = {'a' => 'b'}
    column = Column.new(:foo, 0) { |_, ctx| ctx }
    assert_equal context, column.values_in([], context)
  end

  def test_respects_preprocessor_arity
    context = {'a' => 'b'}
    column = Column.new(:foo, 0, &lambda { |values| })
    column.values_in([], context)
  end
end
