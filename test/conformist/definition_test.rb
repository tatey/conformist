require 'helper'

class DefinitionTest < MiniTest::Unit::TestCase
  def test_initialize
    definition = Definition.new
    assert_equal Builder, definition.builder
    assert_empty definition.columns
  end
  
  def test_initialize_with_definition
    parent = Definition.new.tap { |d| d.columns = [0] }
    child1 = Definition.new(parent).tap { |d| d.columns << 1 }
    child2 = Definition.new(parent).tap { |d| d.columns << 2 }
    assert_equal [0], parent.columns
    assert_equal [0, 1], child1.columns
    assert_equal [0, 2], child2.columns
  end
  
  def test_initialize_with_block
    definition = Definition.new do
      column :a, 0
      column :b, 1
    end
    assert_equal 2, definition.columns.size
  end
  
  def test_column
    definition = Definition.new
    definition.column :a, 0
    definition.column :b, 1
    assert_equal 2, definition.columns.size
  end
  
  def test_conform_returns_enumerable
    definition = Definition.new
    assert definition.conform([]).respond_to?(:each)
    assert definition.conform([]).respond_to?(:map)
  end

  def test_conform_calls_builders_call_method
    definition = Definition.new
    definition.builder = lambda { |definition, value| value }
    assert_equal [2, 4], definition.conform([1, 2]).map { |value| value * 2 }
  end
end
