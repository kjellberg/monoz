# frozen_string_literal: true

require "thor"
require "yaml"
require "fileutils"

module Monoz
  module Cli
    class Main < Thor
      class_option :src, type: :string, desc: "Set the source directory for your monozrepo"

      desc "init [PATH]", "Initialize a monozrepo at the specified PATH"
      def init(path = ".")
        config_file_path = File.join(File.expand_path(path), "monoz.yml")
        project_dir = File.dirname(config_file_path)

        if File.exist?(config_file_path)
          say "Error: monoz.yaml already exists in #{config_file_path}", :red
          return
        end

        FileUtils.mkdir_p(project_dir)
        FileUtils.mkdir_p(File.join(project_dir, "apps"))
        FileUtils.mkdir_p(File.join(project_dir, "gems"))
        FileUtils.touch(File.join(project_dir, "apps/.keep"))
        FileUtils.touch(File.join(project_dir, "gems/.keep"))
        File.write(config_file_path, Monoz::Configuration.default_config.to_yaml)

        FileUtils.chdir(project_dir) do
          system "git", "init"
        end

        say "Successfully initialized Monoz in #{project_dir}", :green
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
