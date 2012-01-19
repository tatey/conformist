require 'helper'

class Conformist::BuilderTest < MiniTest::Unit::TestCase
  def test_call
    column = MiniTest::Mock.new
    column.expect :name, :a
    column.expect :values_in, [1], [Array]
    definition = MiniTest::Mock.new
    definition.expect :columns, [column]
    assert_equal HashStruct.new({:a => [1]}), Builder.call(definition, [])
  end
end
