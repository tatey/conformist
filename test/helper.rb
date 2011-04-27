require 'minitest/autorun'

require 'conformist'
require 'definitions/acma'
require 'definitions/fcc'

def stub_row
  ('a'..'d').to_a
end

def fixture file
  File.expand_path "../fixtures/#{file}", __FILE__
end
