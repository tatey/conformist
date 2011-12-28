require 'helper'

class HashWithReadersTest < MiniTest::Unit::TestCase
  def test_initialize
    assert_equal({:a => 1}, HashWithReaders.new({:a => 1}).attributes)
    assert_empty HashWithReaders.new.attributes
  end
  
  def test_delegates
    hash = HashWithReaders.new
    assert hash.respond_to?(:[])
    assert hash.respond_to?(:[]=)
  end
  
  def test_merge
    hash1 = HashWithReaders.new
    hash2 = hash1.merge :a => 1
    refute_equal hash1.object_id, hash2.object_id
    assert_equal({:a => 1}, hash2.attributes)
  end
  
  def test_readers
    hash = HashWithReaders.new
    hash[:a] = nil
    hash[:c_d] = nil
    assert hash.respond_to?(:a)
    assert hash.respond_to?(:c_d)
  end
end
