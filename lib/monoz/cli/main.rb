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

      # desc "bundle [COMMAND]", "Run bundle commands in all projects"
      # def bundle(*command)
      #   Monoz::Services::BundleService.new(self).call(*command)
      # end

      desc "inspect", "Inspect this monozrepo"
      subcommand "inspect", Monoz::Cli::Inspect

      map "run" => "run_action"
      desc "run [COMMAND]", "Run commands in all projects"
      def run_action(*command)
        # return help("run") if command.nil? || keys == "help"

        projects = Monoz.projects.order(:dependants)
        response = Monoz::Services::RunService.new(self).call(projects, *command)

        say ""
        say "The command ran successfully in all projects without any errors.", [:green] if response.success?

        if response.errors?
          say "Error: The command ", :red
          say "#{command.join(" ")} ", [:red, :bold]
          say "failed to run in one or more projects", [:red]
          exit(1)
        end
      end

      desc "version", "Get the current version of Monoz"
      def version
        say "Monoz version: #{Monoz::VERSION}"
      end
    end
  end
end
