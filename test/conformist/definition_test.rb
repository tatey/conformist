require 'helper'

class DefinitionTest < MiniTest::Unit::TestCase
  def test_initialize_sets_attributes
    definition = Definition.new
    assert_equal Row, definition.conformer
    assert_empty definition.columns
  end
  
  def test_initialize_takes_a_block_for_setup
    definition = Definition.new do
      column :a, 0
      column :b, 1
    end
    assert_equal 2, definition.size
  end
  
  def test_each
    definition = Definition.new
    definition.columns = ['a', 'b']
    definition.each do |letter|
      assert_instance_of String, letter
    end
  end
  
  def test_column
    definition = Definition.new
    definition.column :a, 0
    definition.column :b, 1
    assert_equal 2, definition.size
  end
  
  def test_conform_returns_enumerable
    definition = Definition.new
    assert definition.conform([]).respond_to?(:each)
    assert definition.conform([]).respond_to?(:map)
  end

  def test_conform_calls_conformers_call_method
    definition = Definition.new
    definition.conformer = lambda { |definition, value| value }
    assert_equal [2, 4], definition.conform([1, 2]).map { |value| value * 2 }
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
