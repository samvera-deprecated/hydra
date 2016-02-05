# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hydra/version'

Gem::Specification.new do |gem|
  gem.name          = "hydra"
  gem.version       = Hydra::VERSION
  gem.authors       = [
    "Jeremy Friesen", "Justin Coyne"
  ]
  gem.email         = [
    "jeremy.n.friesen@gmail.com",
    "jcoyne@justincoyne.com",
  ]
  gem.description   = %q{Project Hydra Stack Dependencies}
  gem.summary       = %q{Project Hydra Stack Dependencies}
  gem.homepage      = "http://projecthydra.org/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.license = 'APACHE2'

  gem.add_dependency 'fcrepo_wrapper', '~> 0.2.1'
  gem.add_dependency 'active-fedora', '~> 9.8.2'
  gem.add_dependency 'hydra-head', '~> 9.6.0'
  gem.add_dependency 'rails', '~> 4.2'
  gem.add_dependency 'om', '~> 3.1.0'
  gem.add_dependency 'solrizer', '~> 3.3.0'
  gem.add_dependency 'rsolr', '~> 1.0.13'
  gem.add_dependency 'blacklight', '~> 6.0.1'
  gem.add_dependency 'nokogiri', '~> 1.6.7'
  gem.add_dependency 'ldp', '~> 0.4.1'
  gem.add_dependency 'active-triples', '~> 0.7.4'
  gem.add_dependency 'nom-xml', '~> 0.5.1'
  gem.add_development_dependency 'github_api', '~> 0.13'
end
