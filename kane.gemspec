# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kane/version'

Gem::Specification.new do |spec|
  spec.name          = "kane"
  spec.version       = Kane::VERSION
  spec.authors       = ["Jordi Polo"]
  spec.email         = ["mumismo@gmail.com"]

  spec.summary       = %q{Kane finds if the projects in your organization are good citizens}
  spec.description   = %q{Kane finds if the projects in your organization are good citizens}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.10"
  spec.add_dependency 'faraday'
  spec.add_dependency 'semverly'
  spec.add_dependency 'octokit'
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'byebug', '~> 8.0'
  spec.add_development_dependency "rspec"

end
