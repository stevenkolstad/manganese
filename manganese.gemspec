# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'manganese/version'

Gem::Specification.new do |spec|
  spec.name          = "manganese"
  spec.version       = Manganese::VERSION
  spec.authors       = ["Marco Sanson", "Andrea Dal Ponte"]
  spec.email         = ["marco.sanson@gmail.com", "dalpo85@gmail.com"]
  spec.summary       = %q{Mongoid multi tenant using multiple database}
  spec.description   = %q{Mongoid multi tenant using multiple database}
  spec.homepage      = "https://github.com/marcosanson/manganese"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails",   ">= 4.0.0"
  spec.add_dependency "mongoid", ">= 4.0.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
