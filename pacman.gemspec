# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pacman/version'

Gem::Specification.new do |spec|
  spec.name          = 'pacman'
  spec.version       = Pacman::VERSION
  spec.authors       = ['soloman']
  spec.email         = ['soloman1124@gmail.com']
  spec.summary       = 'Kinesis consumer for events through nark'
  spec.description   = 'Kinesis consumer for events through nark'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'amazon-kinesis-client-ruby', '~> 0.0.1'
  spec.add_runtime_dependency 'configify-rb', '0.0.1'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'rubocop', '~> 0.27.1'
end
