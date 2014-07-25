require 'helper'

class Conformist::BuilderTest < Minitest::Test
  def test_call
    column = Minitest::Mock.new
    column.expect :name, :a
    column.expect :values_in, [1], [Array]
    definition = Minitest::Mock.new
    definition.expect :columns, [column]
    assert_equal HashStruct.new({:a => [1]}), Builder.call(definition, [])
  end
end
