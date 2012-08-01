require 'conformist'
require 'minitest/autorun'

if ['1.8.7', 'java'].include? RUBY_VERSION
  require 'faster_csv'
  ::CSV = FasterCSV
else
  require 'csv'
end

include Conformist
