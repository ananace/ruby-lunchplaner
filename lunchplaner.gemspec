# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lunchplaner/version'

Gem::Specification.new do |spec|
  spec.name          = 'lunchplaner'
  spec.version       = Lunchplaner::VERSION
  spec.authors       = ['Alexander Olofsson']
  spec.email         = ['alexander.olofsson@liu.se']

  spec.summary       = 'Ta hand om lunchplanerna'
  spec.description   = 'Slår upp och listar alla tillgängliga luncher för dagen.'
  spec.homepage      = 'http://liu.se'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^test\/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.bindir        = 'bin'
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '~> 1.8'
  spec.add_dependency 'sinatra', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
