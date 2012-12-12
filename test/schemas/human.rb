class Human
  extend Conformist

  def self.name
    lambda{|values| values[0] + ' ' + values[1]}
  end

  column :name, 'first_name', 'last_name', &name
  column :age, 'age'
  column :gender, 'gender'
end
