require 'rubygems'
require 'bundler/setup'
require 'rake/testtask'

Rake::TestTask.new :test do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
end

task :default => :test
