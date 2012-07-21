# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "buscacep/version"

Gem::Specification.new do |s|
  s.name        = "buscacep"
  s.version     = BuscaCep::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Victor Morandini Stabile"]
  s.email       = ["victor@ipostal.com.br"]
  s.homepage    = "https://ipostal.com.br"
  s.summary     = %q{Busca de cep}
  s.description = %q{Busca de cep por scraping no site mobile dos Correios.}

  s.rubyforge_project = "buscacep"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.has_rdoc = true

  s.add_dependency('nokogiri')
  s.add_development_dependency "rake"
end