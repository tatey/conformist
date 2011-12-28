require 'helper'

class AnonymousTest < MiniTest::Unit::TestCase
  def test_included
    definition = Class.new { include Conformist }
    assert definition.respond_to?(:builder)
    assert definition.respond_to?(:columns)
    assert definition.respond_to?(:conform)
  end
  
  def test_new
    assert_instance_of Anonymous, Conformist.new
  end
end
