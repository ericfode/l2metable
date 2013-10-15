# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'loggable/version'

Gem::Specification.new do |spec|
  spec.name          = "loggable"
  spec.version       = Loggable::VERSION
  spec.authors       = ["ericfode","ryanbrainard"]
  spec.email         = ["ericfode@gmail.com"]
  spec.description   = %q{A mixin to add some nice logging functions that log in the l2met style}
  spec.summary       = %q{l2met logging mixin}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
