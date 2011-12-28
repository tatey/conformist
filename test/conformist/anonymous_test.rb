require 'helper'

class AnonymousTest < MiniTest::Unit::TestCase
  def test_initialize_with_instance
    parent = Anonymous.new.tap { |d| d.columns = [0] }
    child1 = Anonymous.new(parent).tap { |d| d.columns << 1 }
    child2 = Anonymous.new(parent).tap { |d| d.columns << 2 }
    assert_equal [0], parent.columns
    assert_equal [0, 1], child1.columns
    assert_equal [0, 2], child2.columns
  end

  def test_initialize_with_block
    anonymous = Anonymous.new do
      column :a, 0
      column :b, 1
    end
    assert_equal 2, anonymous.columns.size
  end
end
