module Conformist
  class Column
    attr_accessor :name, :attrs, :preprocessor

    def initialize name, *attrs, &preprocessor
      self.name         = name
      self.attrs        = attrs
      self.preprocessor = preprocessor
    end

    def values_in enumerable
      column_indexes = []
      raw_attrs = []
      self.attrs.each { |i| i.is_a?(Integer) ? column_indexes << i : raw_attrs << i }
      values = Array(enumerable).values_at(*column_indexes).map do |value|
        if value.respond_to? :strip
          value.strip
        else
          value
        end
      end
      values += raw_attrs if raw_attrs.any?
      values = values.first if values.size == 1
      if preprocessor
        preprocessor.call values
      else
        values
      end
    end
  end
end
