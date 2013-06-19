# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vcr/xml/version'

Gem::Specification.new do |spec|
  spec.name          = "vcr-xml"
  spec.version       = Vcr::Xml::VERSION
  spec.authors       = ["Vlad Bokov"]
  spec.email         = ["razum2um@mail.ru"]
  spec.description   = %q{Easier SOAP with VCR}
  spec.summary       = %q{Easier SOAP with VCR}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_dependency "vcr", "~> 2.3"
  spec.add_dependency "nokogiri", "~> 1.5"
  spec.add_dependency "diffy", "~> 2.1.4"
  spec.add_dependency "hirb", "~> 0.5"
  spec.add_dependency "equivalent-xml", "~> 0.3.0"
  spec.add_dependency "activesupport", ">= 3.2.0"
  spec.add_dependency "i18n", ">= 0.5.0"
  spec.add_dependency "syck" if RUBY_VERSION >= "2.0.0"
end
