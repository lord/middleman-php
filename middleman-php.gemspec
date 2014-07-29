# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-php/version"

Gem::Specification.new do |s|
  s.name        = "middleman-php"
  s.version     = Middleman::Php::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Robert Lord"]
  s.email       = ["robert@lord.io"]
  s.homepage    = "https://github.com/lord/middleman-php"
  s.summary     = %q{Use Middleman to build PHP files}
  # s.description = %q{A longer description of your extension}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("middleman-core", [">= 3.2.1"])
end
