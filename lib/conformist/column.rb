module Conformist
  class Column
    attr_accessor :name, :sources, :indexes, :preprocessor

    def initialize name, *sources, &preprocessor
      self.name         = name
      self.sources      = sources
      self.indexes      = sources
      self.preprocessor = preprocessor
    end

    def calculate_indices!(headers)
      headers = Array(headers).collect {|header| header.to_s.downcase.squeeze(' ').strip }

      self.indexes = sources.collect do |source|
        if source.is_a?(String)
          headers.index(source.downcase)
        else
          source
        end
      end
    end

    def values_in enumerable, context = nil
      enumerable = Array(enumerable)

      values = Array(indexes).map do |index|
        value = enumerable.at(index) if index

        if value.respond_to? :strip
          value.strip
        else
          value
        end
      end
      values = values.first if values.size == 1
      if preprocessor
        if preprocessor.arity == 1
          preprocessor.call values
        else
          preprocessor.call values, context
        end
      else
        values
      end
    end
  end
end
