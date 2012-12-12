module Conformist
  class Column
    attr_accessor :name, :source_columns, :preprocessor

    def initialize name, *source_columns, &preprocessor
      self.name           = name
      self.source_columns = source_columns
      self.preprocessor   = preprocessor || lambda{|a| a}
    end

    def values_in enumerable
      enumerable = Array(enumerable)
      values = source_columns.collect do |source_column|
        value = (
          if enumerable.first.is_a?(Array)
            if detected_header_value_pair = enumerable.detect{|header_value_pair| header_value_pair.first == source_column}
              detected_header_value_pair.last
            else
              enumerable[source_column].last
            end
          else
            enumerable[source_column]
          end
        )
        value.respond_to?(:strip) ? value.strip : value
      end
      values = values.size == 1 ? values.first : values
      preprocessor.call(values)
    end

  end
end
