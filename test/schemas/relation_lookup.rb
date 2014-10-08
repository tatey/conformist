class RelationLookup
  extend Conformist

  column :name, 0, 1, { agent_id: '007' } do |values|
    "#{values[0]}, #{values[1]}, (observed by #{values[2][:agent_id]})"
  end
end
