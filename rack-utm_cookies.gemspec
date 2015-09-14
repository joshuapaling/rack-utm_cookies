# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/utm_cookies/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-utm_cookies"
  spec.version       = Rack::UtmCookies::VERSION
  spec.authors       = ["Joshua Paling"]
  spec.email         = ["joshua.paling@gmail.com"]

  spec.summary       = %q{A rack middleware that searches for UTM tags in the request params, and stores them in cookies for later use.}
  spec.homepage      = "https://github.com/joshuapaling/rack-utm_cookies"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
