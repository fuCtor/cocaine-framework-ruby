# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cocaine/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'cocaine'
  s.version = Cocaine::VERSION
  s.homepage = 'https://github.com/cocaine/cocaine-framework-ruby'
  s.licenses = %w(Ruby LGPLv3)

  s.authors = ['Evgeny Safronov']
  s.email   = ['division494@gmail.com']

  s.files = `git ls-files`.split("\n")
  s.extensions = []

  s.summary = 'Ruby/Cocaine library'
  s.description = 'Cocaine Framework is a framework for simplifying development both server-side and client-side
applications.'

  s.add_development_dependency 'rspec', '~> 0'

  s.add_runtime_dependency 'msgpack', '~> 0.5'
  s.add_runtime_dependency 'celluloid', '~> 0.13'
  s.add_runtime_dependency 'celluloid-io', '~> 0.13'
end