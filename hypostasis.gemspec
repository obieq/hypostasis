# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hypostasis/version'

Gem::Specification.new do |spec|
  spec.name          = 'hypostasis'
  spec.version       = Hypostasis::VERSION
  spec.authors       = ['James Thompson']
  spec.email         = %w{james@plainprograms.com}
  spec.description   = %q{A layer for FoundationDB providing multiple data models for Ruby.}
  spec.summary       = %q{A layer for FoundationDB providing multiple data models for Ruby.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w{lib}

  spec.add_dependency 'fdb', '~> 1.0.1'
  spec.add_dependency 'activesupport', '>= 3.2.0'
  spec.add_dependency 'bson', '~> 2.2'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 5.2.0'
  spec.add_development_dependency 'tzinfo'
end
