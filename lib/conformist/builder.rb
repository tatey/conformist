module Conformist
  class Builder
    def self.call schema, enumerable, context = nil
      columns = schema.columns
      hash = columns.each_with_object({}) do |column, hash|
        hash[column.name] = column.values_in(enumerable, context)
      end
      HashStruct.new hash
    end
  end
end
