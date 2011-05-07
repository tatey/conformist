class ACMA
  include Conformist::Base
  
  option :col_sep => ','
  option :quote_char => '"'

  column :name, 11 do |value| 
    value.match(/[A-Z]+$/)[0].upcase
  end
  column :callsign, 1
  column :latitude, 15
end

class ACMA::Digital < ACMA
  column :signtal_type do 
     'digital'
   end
 end

class ACMA::Analogue < ACMA
  column :signtal_type do 
    'analogue'
  end
end
