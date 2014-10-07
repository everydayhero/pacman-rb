# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pacman/version'

Gem::Specification.new do |spec|
  spec.name          = "pacman"
  spec.version       = Pacman::VERSION
  spec.authors       = ["soloman"]
  spec.email         = ["soloman1124@gmail.com"]
  spec.summary       = %q{Kafka consumer for events through nark}
  spec.description   = %q{Kafka consumer for events through nark}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "poseidon_cluster", "~> 0.1.1"
end
