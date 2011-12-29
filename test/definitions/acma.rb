class ACMA
  extend Conformist

  column :name, 11 do |value| 
    value.match(/[A-Z]+$/)[0].upcase
  end
  column :callsign, 1
  column :latitude, 15
end

class ACMA::Digital < ACMA
  column :signal_type do 
     'digital'
   end
end
