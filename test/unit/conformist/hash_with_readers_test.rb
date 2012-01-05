require 'helper'

class HashStructTest < MiniTest::Unit::TestCase
  def test_initialize
    assert_equal({:a => 1}, HashStruct.new({:a => 1}).attributes)
    assert_empty HashStruct.new.attributes
  end
  
  def test_delegates
    hash = HashStruct.new
    assert hash.respond_to?(:[])
    assert hash.respond_to?(:[]=)
    assert hash.respond_to?(:fetch)
    assert hash.respond_to?(:key?)
  end
  
  def test_merge
    hash1 = HashStruct.new
    hash2 = hash1.merge :a => 1
    refute_equal hash1.object_id, hash2.object_id
    refute_equal 1, hash1[:a]
    assert_equal 1, hash2[:a]
  end
  
  def test_readers_with_method_missing
    hash = HashStruct.new :a => 1, :c_d => 1
    assert_equal 1, hash.a
    assert_equal 1, hash.c_d
  end
  
  if respond_to? :respond_to_missing? # Compatible with 1.9
    def test_readers_with_respond_to_missing
      hash = HashStruct.new :a => 1, :c_d => 1
      assert hash.respond_to?(:a)
      assert hash.respond_to?(:c_d)
    end
  end
end
