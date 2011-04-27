require 'helper'

class RowTest < MiniTest::Unit::TestCase
  def test_to_hash_should_join_array
    column = Conformist::Column.new(:foo, 0, 1, 2)
    row    = Conformist::Row.new [column], stub_row
    assert_equal({:foo => 'abc'}, row.to_hash)
  end
  
  def test_to_hash_should_not_join_string
    column = Conformist::Column.new(:foo, 0, 1, 2) { |values| values.join('-').upcase }
    row    = Conformist::Row.new [column], stub_row
    assert_equal({:foo => 'A-B-C'}, row.to_hash)
  end
  
  def test_to_hash_with_many_columns
    columns = Conformist::Column.new(:foo, 0), Conformist::Column.new(:bar, 1, 2, 3)
    row     = Conformist::Row.new columns, stub_row
    assert_equal({:foo => 'a', :bar => 'bcd'}, row.to_hash)
  end
end
