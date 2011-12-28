require 'helper'

class DefinitionTest < MiniTest::Unit::TestCase
  def test_builder_reader
    assert_equal Builder, Class.new { extend Definition }.builder
  end
  
  def test_builder_writer
    definition = Class.new { extend Definition }
    definition.builder = Object
    assert_equal Object, definition.builder
  end  
  
  def test_columns_reader
    assert_empty Class.new { extend Definition }.columns
  end
  
  def test_columns_writer
    definition = Class.new { extend Definition }
    definition.columns = [1]
    assert_equal [1], definition.columns
  end
  
  def test_column
    definition = Class.new { extend Definition }
    definition.column :a, 0
    definition.column :b, 1
    assert_equal 2, definition.columns.size
  end
  
  def test_conform_returns_enumerable
    definition = Class.new { extend Definition }
    assert definition.conform(nil).respond_to?(:each)
    assert definition.conform(nil).respond_to?(:map)
  end
  
  def test_conform_calls_builders_call_method
    definition = Class.new { extend Definition }
    definition.builder = lambda { |definition, value| value }
    assert_equal [2, 4], definition.conform([1, 2]).map { |value| value * 2 }
  end
end
