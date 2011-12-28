require 'helper'

class ConformistTest < MiniTest::Unit::TestCase
  def test_included
    definition = Class.new { extend Conformist }
    assert definition.respond_to?(:builder)
    assert definition.respond_to?(:columns)
    assert definition.respond_to?(:conform)
  end
  
  def test_new
    assert Conformist.new.class.include?(Definition)
  end
end
