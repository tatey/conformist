require 'helper'

class BuilderTest < MiniTest::Unit::TestCase
  def test_call
    column = MiniTest::Mock.new
    column.expect :name, :a
    column.expect :values_in, [1], [Array]
    definition = MiniTest::Mock.new
    definition.expect :columns, [column]
    assert_equal({:a => [1]}, Builder.call(definition, []).store)
  end
end
