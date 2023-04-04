# frozen_string_literal: true

require "thor"
require "yaml"
require "fileutils"

module Monoz
  module Cli
    class Main < Thor
      desc "init [PATH]", "Initialize a monozrepo at the specified PATH"
      def init(path = ".")
        Monoz::Services::InitService.new(self).call(path)
      end

      desc "bundle", "Run bundle commands in all projects"
      subcommand "bundle", Monoz::Cli::Bundle

      desc "inspect", "Inspect this monozrepo"
      subcommand "inspect", Monoz::Cli::Inspect

      map "run" => "run_action"
      desc "run [action]", "Run commands in all projects"
      def run_action(keys = nil)
        return help("run") if keys.nil? || keys == "help"

        Monoz::Services::RunActionService.new(self).call(keys)
      end

      desc "version", "Get the current version of Monoz"
      def version
        say "Monoz version: #{Monoz::VERSION}"
      end
    end
  end
end
