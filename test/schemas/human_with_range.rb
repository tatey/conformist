class HumanWithRange
  extend Conformist

  def self.name
    lambda{|values| values[0] + ' ' + values[1]}
  end

  column :name, 0..1, &name
  column :age, 2
  column :gender, 'gender'
end
