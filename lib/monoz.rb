# frozen_string_literal: true

require_relative "monoz/version"

module Monoz
  class Error < StandardError; end

  module Cli
    autoload "Main", "monoz/cli/main"
  end
end
