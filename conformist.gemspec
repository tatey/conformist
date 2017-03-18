# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "conformist/version"

Gem::Specification.new do |s|
  s.name                 = "conformist"
  s.version              = Conformist::VERSION
  s.platform             = Gem::Platform::RUBY
  s.authors              = ["Tate Johnson"]
  s.email                = ["tate@tatey.com"]
  s.homepage             = "https://github.com/tatey/conformist"
  s.summary              = %q{Bend CSVs to your will with declarative schemas.}
  s.description          = %q{Bend CSVs to your will with declarative schemas.}

  s.rubyforge_project = "conformist"

  s.required_ruby_version = '>= 1.9.3'

  s.add_development_dependency 'minitest', '>= 5.4.0'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'spreadsheet', '>= 1.1.4'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
