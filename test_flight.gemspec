# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "#{lib}/test_flight/version"

Gem::Specification.new do |spec|
  spec.name          = "test_flight"
  spec.version       = TestFlight::VERSION
  spec.authors       = ["Callum Anderson"]
  spec.email         = ["callum.anderson@mendeley.com"]
  spec.description   = "Gem to push builds to testflight"
  spec.summary       = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ["test_flight"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "httparty"
  spec.add_dependency "rest-client"
end
