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
      headers = Array(headers).collect {|header| header.to_s.downcase }

      self.indexes = sources.collect do |source|
        if source.is_a?(String)
          headers.index(source.downcase)
        else
          source
        end
      end.compact
    end

    def values_in enumerable
      values = Array(enumerable).values_at(*indexes).map do |value|
        if value.respond_to? :strip
          value.strip
        else
          value
        end
      end
      values = values.first if values.size == 1
      if preprocessor
        preprocessor.call values
      else
        values
      end
    end
  end
end
