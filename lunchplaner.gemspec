# frozen_string_literal: true

require File.join File.expand_path('lib', __dir__), 'lunchplaner/version'

Gem::Specification.new do |spec|
  spec.name          = 'lunchplaner'
  spec.version       = Lunchplaner::VERSION
  spec.authors       = ['Alexander Olofsson']
  spec.email         = ['alexander.olofsson@liu.se']

  spec.summary       = 'Ta hand om lunchplanerna'
  spec.description   = 'Listar alla lunchresturanger vid LiU.'
  spec.homepage      = 'http://gitlab.liu.se/aleol57/lunchplaner'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.0'

  spec.files         = Dir['{Gemfile,Rakefile,config.ru,lunchplaner.gemspec,{lib,test}/**/*.rb,bin/*}'].select { |f| File.file? f }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.bindir        = 'bin'
  spec.require_paths = ['lib']

  spec.add_dependency 'mini_cache', '~> 1.1'
  spec.add_dependency 'nokogiri', '~> 1.8'
  spec.add_dependency 'prometheus-client', '~> 0.8'
  spec.add_dependency 'sinatra', '~> 2.0'
  spec.add_dependency 'thin'
end
