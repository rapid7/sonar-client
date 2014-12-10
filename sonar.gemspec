# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sonar/version'

Gem::Specification.new do |spec|
  spec.name          = "sonar"
  spec.version       = Sonar::VERSION
  spec.authors       = ["Paul Deardorff & HD Moore"]
  spec.email         = ["paul_deardorff@rapid7.com", "hd_moore@rapid7.com"]
  spec.description   = %q{API Wrapper for Sonar}
  spec.summary       = spec.description
  spec.homepage      = "https://sonar.labs.rapid7.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday_middleware', '~> 0.9.0'
  spec.add_dependency 'hashie', '~> 2.0.3'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'thor'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-rcov"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "vcr", '~> 2.8.0'
  spec.add_development_dependency "shoulda"
  spec.add_development_dependency "webmock", '~> 1.8.0'
  spec.add_development_dependency "api_matchers"
end
