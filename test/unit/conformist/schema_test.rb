require 'helper'

class Conformist::SchemaTest < Minitest::Test
  def test_initialize_with_instance
    parent = Class.new { include Schema }.new.tap { |d| d.columns = [0] }
    child1 = Class.new { include Schema }.new(parent).tap { |d| d.columns << 1 }
    child2 = Class.new { include Schema }.new(parent).tap { |d| d.columns << 2 }
    assert_equal [0], parent.columns
    assert_equal [0, 1], child1.columns
    assert_equal [0, 2], child2.columns
  end

  def test_initialize_with_block
    anonymous = Class.new { include Schema }.new do
      column :a, 0
      column :b, 1
    end
    assert_equal 2, anonymous.columns.size
  end

  def test_builder_reader
    assert_equal Builder, Class.new { extend Schema }.builder
  end

  def test_builder_writer
    definition = Class.new { extend Schema }
    definition.builder = Object
    assert_equal Object, definition.builder
  end

  def test_columns_reader
    assert_empty Class.new { extend Schema }.columns
  end

  def test_columns_writer
    definition = Class.new { extend Schema }
    definition.columns = [1]
    assert_equal [1], definition.columns
  end

  def test_column
    definition = Class.new { extend Schema }
    definition.column :a, 0
    definition.column :b, 1
    assert_equal 2, definition.columns.size
  end

  def test_column_with_implict_index
    definition = Class.new { extend Schema }
    definition.column :a
    definition.column :b
    assert_equal [0, 1], definition.columns.map { |column| column.indexes }.flatten
  end

  def test_conform_returns_enumerable
    definition = Class.new { extend Schema }
    assert definition.conform([]).respond_to?(:each)
    assert definition.conform([]).respond_to?(:map)
  end

  def test_conform_skip_first
    definition = Class.new { extend Schema }
    definition.column :a, 0
    assert_equal HashStruct.new({:a => 'value'}), definition.conform(['header', 'value'], :skip_first => true).first
  end

  def test_conform_calls_builders_call_method
    definition = Class.new { extend Schema }
    definition.builder = lambda { |definition, value, context| value }
    assert_equal [2, 4], definition.conform([1, 2]).map { |value| value * 2 }
  end

  def test_inheritance
    parent = Class.new { extend Schema }.tap { |d| d.columns = [0] }
    child1 = Class.new(parent).tap { |d| d.columns << 1 }
    child2 = Class.new(parent).tap { |d| d.columns << 2 }
    assert_equal [0], parent.columns
    assert_equal [0, 1], child1.columns
    assert_equal [0, 2], child2.columns
  end
end
