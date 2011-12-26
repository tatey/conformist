require 'helper'

class DefinitionTest < MiniTest::Unit::TestCase
  def test_initialize
    definition = Definition.new
    assert_empty definition.columns
  end
end
