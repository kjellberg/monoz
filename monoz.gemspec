# frozen_string_literal: true

require_relative "lib/monoz/version"

Gem::Specification.new do |spec|
  spec.name = "monoz"
  spec.version = Monoz::VERSION
  spec.authors = ["kjellberg"]
  spec.email = ["2277443+kjellberg@users.noreply.github.com"]

  spec.summary = "Command line tool for managing ruby monorepos."
  spec.description = "Command line tool for managing ruby monorepos."
  spec.homepage = "https://github.com/kjellberg/monoz"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kjellberg/monoz"
  spec.metadata["changelog_uri"] = "https://github.com/kjellberg/monoz"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir["lib/**/*", "MIT-LICENSE", "README.md"]
  spec.executables = %w[ monoz ]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "thor", "~> 1.2"
end
