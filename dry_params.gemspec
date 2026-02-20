# frozen_string_literal: true

require_relative "lib/dry_params/version"

Gem::Specification.new do |spec|
  spec.name = "dry_params"
  spec.version = DryParams::VERSION
  spec.authors = ["rodrinbarreto"]
  spec.email = ["rodrigonbarreto@gmail.com"]

  spec.summary = "Convert Dry::Validation contracts to framework params"
  spec.description = "Automatically generate Grape params or Rails strong params from Dry::Validation contracts"
  spec.homepage = "https://github.com/rodrigonbarreto/dry_params"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "dry-validation", ">= 1.0"

  # Development dependencies
  spec.add_development_dependency "grape", ">= 1.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
end