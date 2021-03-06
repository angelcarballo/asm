# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asm/version'

Gem::Specification.new do |spec|
  spec.name          = "asm"
  spec.version       = Asm::VERSION
  spec.authors       = ["Angel Carballo"]
  spec.email         = ["contact@angelcarballo.com"]
  spec.description   = %q{ASM Shipment Client}
  spec.summary       = %q{This gem provides integration with ASM Services}
  spec.homepage      = "https://github.com/angelcarballo/asm/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'savon', '~> 2.3.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry"
end
