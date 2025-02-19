Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY
  spec.name        = "ofstruct"
  spec.version     = "0.3.0"
  spec.summary     = "OpenFastStruct"
  spec.description = "OpenFastStruct is a data structure, similar to an OpenStruct but faster."
  spec.author      = "Arturo Herrero"
  spec.email       = "arturo.herrero@gmail.com"
  spec.homepage    = "https://github.com/arturoherrero/ofstruct"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 2.0.0"

  spec.files         = Dir["{lib}/**/*", "LICENSE", "README.md"]
  spec.test_files    = Dir["spec/**/*"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "rake", "~> 13.0"

  spec.add_development_dependency "benchmark-ips", "~> 2.10"
  spec.add_development_dependency "benchmark-memory"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "hashie"
  spec.add_development_dependency "recursive-open-struct"
end
