require 'conformist'
require 'minitest/autorun'

include Conformist

def stub_row
  ('a'..'d').to_a
end

def fixture file
  File.expand_path "../fixtures/#{file}", __FILE__
end
