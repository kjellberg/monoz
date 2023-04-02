# frozen_string_literal: true

require "thor"
require "pathname"
 
module Monoz
  module Cli
    class Main < Thor
      desc "init", "Initialize your monorepo"
      def init
        say "Hello from init"
      end

      desc "inspect", "Inspect the monorepo"
      def inspect
        current_dir = Pathname.new(Dir.pwd)
        projects = Monoz::ProjectCollection.new(current_dir)

        pp projects.all
      end

      desc "version", "Get the current version of Monoz"
      def version
        say "Monoz version: #{Monoz::VERSION}"
      end
    end
  end
end
