require 'helper'

class HashWithReadersTest < MiniTest::Unit::TestCase
  def test_initialize
    assert_empty HashWithReaders.new.store
  end
  
  def test_delegates
    hash = HashWithReaders.new
    assert hash.respond_to?(:[])
    assert hash.respond_to?(:[]=)
    assert hash.respond_to?(:delete)
    assert hash.respond_to?(:merge)
  end
  
  def test_readers
    hash = HashWithReaders.new
    hash[:a] = nil
    hash[:c_d] = nil
    assert hash.respond_to?(:a)
    assert hash.respond_to?(:c_d)
  end
end
