require 'helper'

class BuilderTest < MiniTest::Unit::TestCase
  def test_included
    assert_raises RuntimeError do
      Class.new { include Base }
    end
  end
end
