# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'projecthydra/version'

Gem::Specification.new do |gem|
  gem.name          = "projecthydra"
  gem.version       = Projecthydra::VERSION
  gem.authors       = ["Jeremy Friesen"]
  gem.email         = ["jeremy.n.friesen@gmail.com"]
  gem.description   = %q{}
  gem.summary       = %q{}
  gem.homepage      = "http://projecthydra.org/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'hydra-head', '6.0.0'
  gem.add_dependency 'active-fedora', '6.0.0'
  gem.add_dependency 'rails', '~> 3.2.13'
  gem.add_dependency 'om', '2.0.0'
  gem.add_dependency 'solrizer', '3.0.0'
  gem.add_dependency 'rsolr', '2.0.0'
  gem.add_dependency 'blacklight', '4.1.0'
  gem.add_dependency 'nokogiri', '1.5.9'
  gem.add_dependency 'rubydora', '1.6.1'
  gem.add_dependency 'nom-xml', '0.5.1'

end
