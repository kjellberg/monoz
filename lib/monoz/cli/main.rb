# frozen_string_literal: true

require "thor"

module Monoz
  module Cli
    class Main < Thor
      desc "init", "Initialize your monorepo"
      def init
        say "Hello from init"
      end

      desc "inspect", "Inspect the monorepo"
      def inspect
        say "List all available apps and gems"
      end

      desc "version", "Get the current version of Monoz"
      def version
        say "Monoz version: #{Monoz::VERSION}"
      end
    end
  end
end
