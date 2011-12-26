require 'helper'

class DefinitionTest < MiniTest::Unit::TestCase
  def test_initialize
    definition = Definition.new
    assert_empty definition.columns
  end
  
  def test_column
    definition = Definition.new
    definition.column :a, 0
    definition.column :b, 1
    assert_equal 2, definition.size
  end
  
  def test_reference
    definition = Definition.new
    definition.columns = ['a', 'b']
    assert_equal 'a', definition[0]
    assert_equal 'b', definition[1]
  end
  
  def test_size
    definition = Definition.new
    definition.columns = [1, 2]
    assert_equal 2, definition.size
  end
end
