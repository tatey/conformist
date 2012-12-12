class Human
  extend Conformist

  def self.name
    lambda{|values| values[0] + ' ' + values[1]}
  end

  column :name, 'first_name', 'last_name', &name
  column :age, 2
  column :gender, 'gender'
end
