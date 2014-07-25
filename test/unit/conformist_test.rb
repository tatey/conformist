require 'helper'

class ConformistTest < Minitest::Test
  def test_extended
    definition = Class.new { extend Conformist }
    assert definition.respond_to?(:builder)
    assert definition.respond_to?(:columns)
    assert definition.respond_to?(:conform)
  end

  def test_new
    assert Conformist.new.class.include?(Schema)
  end
end
