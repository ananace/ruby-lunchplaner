require File.join File.expand_path('lib', __dir__), 'lunchplaner/version'

Gem::Specification.new do |spec|
  spec.name          = 'lunchplaner'
  spec.version       = Lunchplaner::VERSION
  spec.authors       = ['Alexander Olofsson']
  spec.email         = ['alexander.olofsson@liu.se']

  spec.summary       = 'Ta hand om lunchplanerna'
  spec.description   = 'Slår upp och listar alla tillgängliga luncher för dagen.'
  spec.homepage      = 'http://gitlab.liu.se/aleol57/lunchplaner'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^test\/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.bindir        = 'bin'
  spec.require_paths = ['lib']

  spec.add_dependency 'mini_cache', '~> 1.1'
  spec.add_dependency 'nokogiri', '~> 1.8'
  spec.add_dependency 'sinatra', '~> 2.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
end
