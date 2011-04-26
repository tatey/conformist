require 'conformist'
require 'minitest/autorun'

include Conformist

class ACMA
  include Base
  
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

class FCC
  include Base
  
  option :col_sep => '|'
   
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

def stub_row
  ('a'..'d').to_a
end

def fixture file
  File.expand_path "../fixtures/#{file}", __FILE__
end
