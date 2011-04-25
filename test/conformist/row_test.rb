require 'helper'

class RowTest < MiniTest::Unit::TestCase
  def test_to_hash_should_join_array
    column = Column.new(:foo, 0, 1, 2)
    row    = Row.new [column], stub_row
    assert_equal({:foo => 'abc'}, row.to_hash)
  end
  
  def test_to_hash_should_not_join_string
    column = Column.new(:foo, 0, 1, 2) { |values| values.join('-').upcase }
    row    = Row.new [column], stub_row
    assert_equal({:foo => 'A-B-C'}, row.to_hash)
  end
  
  def test_to_hash_with_many_columns
    columns = Column.new(:foo, 0), Column.new(:bar, 1, 2, 3)
    row     = Row.new columns, stub_row
    assert_equal({:foo => 'a', :bar => 'bcd'}, row.to_hash)
  end
end
