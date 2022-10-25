# frozen_string_literal: true

require_relative "lib/firebase/admin/version"

Gem::Specification.new do |spec|
  spec.name = "firebase-admin-sdk"
  spec.version = Firebase::Admin::VERSION
  spec.authors = ["Tariq Zaid"]
  spec.email = ["tariq@cheddar.me"]

  spec.summary = "Firebase Admin SDK for Ruby"
  spec.homepage = "https://github.com/cheddar-me/firebase-admin-sdk-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = "> 2.7"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "bin"
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "googleauth", "> 0.16", "< 2.0"
  spec.add_runtime_dependency "faraday", "< 3"
  spec.add_runtime_dependency "faraday_middleware", "~> 1.2"
  spec.add_runtime_dependency "jwt", ">= 1.5", "< 3.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.13"
  spec.add_development_dependency "fakefs", "~> 1.3.2"
  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "activesupport"
end
