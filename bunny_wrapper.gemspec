# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunny_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "bunny_wrapper"
  spec.version       = BunnyWrapper::VERSION
  spec.authors       = ["Alex Klimenkov"]
  spec.email         = ["alex.klimenkov89@gmail.com"]
  spec.summary       = %q{Wrapper for Bunny}
  spec.description   = %q{Wrapper for Bunny}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency 'bunny', '~> 1.7'
  spec.add_dependency 'log4r', '~> 1.1'
end
