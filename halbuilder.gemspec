# frozen_string_literal: true

require_relative "lib/halbuilder/version"

Gem::Specification.new do |spec|
  spec.name = "halbuilder"
  spec.version = Halbuilder::VERSION
  spec.authors = ["cavis"]
  spec.email = ["ryan@prx.org"]

  spec.summary = "HAL DSL extensions for Jbuilder."
  spec.homepage = "https://github.com/PRX/halbuilder"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/PRX/halbuilder"
  spec.metadata["changelog_uri"] = "https://github.com/PRX/halbuilder/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/PRX/halbuilder/issues"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 6.0.0"
  spec.add_dependency "jbuilder", ">= 2.0.0"
  spec.add_dependency "kaminari", ">= 1.0.0"
end
