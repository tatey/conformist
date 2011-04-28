# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "conformist/version"

Gem::Specification.new do |s|
  s.name        = "conformist"
  s.version     = Conformist::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tate Johnson"]
  s.email       = ["tate@tatey.com"]
  s.homepage    = "https://github.com/tatey/conformist"
  s.summary     = %q{Let multiple, different input files conform to a single interface.}
  s.description = %q{Conformist lets you bend CSVs to your will. Let multiple, different input files conform to a single interface without rewriting your parser each time.}

  s.rubyforge_project = "conformist"

  s.required_ruby_version = '>= 1.8.7'
  
  s.add_development_dependency 'rake', '~> 0.8.7'
  s.add_development_dependency 'minitest', '~> 2.1.0'
  s.add_dependency 'fastercsv', "~> 1.5.4"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
