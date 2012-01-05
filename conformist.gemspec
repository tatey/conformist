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
  s.summary              = %q{Bend CSVs to your will.}
  s.description          = %q{Stop using array indexing and start using declarative schemas.}
  s.post_install_message = <<-EOS
********************************************************************************

  Upgrading from <= 0.0.3? You should be aware of breaking changes. See
  https://github.com/tatey/conformist and skip to "Upgrading from 0.0.3 to 
  0.1.0" to learn more. Conformist will raise helpful messages where necessary.

********************************************************************************  
EOS

  s.rubyforge_project = "conformist"

  s.required_ruby_version = '>= 1.8.7'
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
