# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "monoz"

def use_example_repo(example_name)
  Monoz.pwd = File.expand_path("../examples/#{example_name}", __dir__)
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
