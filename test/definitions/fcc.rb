class FCC
  extend Conformist
     
  column :name, 10, 11 do |values|
    "#{values[0].upcase}, #{values[-1]}"
  end
  column :callsign, 1
  column :latitude, 20, 21, 22, 19 do |values|
    values.join(' ')
  end
  column :signtal_type do
    'digital'
  end
end
