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

  gem.add_dependency 'fcrepo_wrapper', '~> 0.7.0'
  gem.add_dependency 'solr_wrapper', '~> 0.19.0'
  gem.add_dependency 'active-fedora', '~> 11.1.1'
  gem.add_dependency 'hydra-head', '~> 10.3.4'
  gem.add_dependency 'rails', '~> 5.0.1'
  gem.add_dependency 'solrizer', '~> 3.4.1'
  gem.add_dependency 'rsolr', '~> 1.1.2'
  gem.add_dependency 'blacklight', '~> 6.7.3'
  gem.add_dependency 'nokogiri', '~> 1.7.0'
  gem.add_dependency 'ldp', '~> 0.6.3'
  gem.add_dependency 'active-triples', '~> 0.11.0'
  gem.add_development_dependency 'github_api', '~> 0.14.5'
end
