# frozen_string_literal: true

require "thor"
require "yaml"

module Monoz
  module Cli
    class Main < Thor
      desc "init [PATH]", "Initialize your monorepo at the specified PATH"
      def init(path = ".")
        config_file_path = File.join(File.expand_path(path), "monoz.yaml")

        if File.exist?(config_file_path)
          say "Error: monoz.yaml already exists in #{config_file_path}", :red
          return
        end

        FileUtils.mkdir_p(File.dirname(config_file_path))

        File.write(config_file_path, Monoz::Configuration.default_config.to_yaml)

        say "Created a monoz.yaml file in #{config_file_path}", :green
      end

      desc "bundle", "Run bundle commands in all projects"
      subcommand "bundle", Monoz::Cli::Bundle

      desc "inspect", "Inspect this monozrepo"
      subcommand "inspect", Monoz::Cli::Inspect

      desc "version", "Get the current version of Monoz"
      def version
        say "Monoz version: #{Monoz::VERSION}"
      end
    end
  end
end
