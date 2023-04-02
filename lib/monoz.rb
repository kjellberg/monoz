# frozen_string_literal: true

require_relative "monoz/version"

module Monoz
  class Error < StandardError; end

  autoload "Cli", "monoz/cli"
end
