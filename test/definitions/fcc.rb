class ACMA
  include Conformist::Base
  
  option :col_sep => ','
  option :quote_char => '"'

  column :name, 11 do |value| 
    value.match(/[A-Z]+$/)[0].upcase
  end
  column :callsign, 1
  column :latitude, 15
  column :signtal_type do 
    'digital'
  end
end
