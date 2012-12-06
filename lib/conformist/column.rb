module Conformist
  class Column
    attr_accessor :name, :source_columns, :preprocessor

    def initialize name, *source_columns, &preprocessor
      self.name           = name
      self.source_columns = source_columns
      self.preprocessor   = preprocessor || lambda{|value| value}
    end

    def values_in enumerable
      preprocessor.call(values_in_object(enumerable))
    end
  end

protected

  def values_in_hashlike_object(enumerable)
    values = source_columns.collect do |source_column|
      enumerable[source_column]
    end
    values.size == 1 ? values.first : values
  end

  def values_in_arraylike_object(enumerable)
    values = Array(enumerable).values_at(*source_columns).collect do |value|
      value = value.last if value.is_a?(Array)
      value.respond_to?(:strip) ? value.strip : value
    end
    values.size == 1 ? values.first : values
  end

  def values_in_structlike_object(enumerable)
    values = source_columns.collect do |source_column|
      enumerable.send(source_column)
    end
    values.size == 1 ? values.first : values
  end

  def values_in_object(enumerable)
    if enumerable.respond_to?(:[])
      if /^(\d+)$/.match(source_columns.first.to_s) && /^(\d+)$/.match(source_columns.first.to_s).captures
        values_in_arraylike_object(enumerable)
      else
        values_in_hashlike_object(enumerable)
      end
    else
      values_in_structlike_object(enumerable)
    end
  end

end
