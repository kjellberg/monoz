# frozen_string_literal: true

require "thor"
require "yaml"
require "fileutils"

module Monoz
  class Application < Thor
    desc "init [PATH]", "Initialize a monozrepo at the specified PATH"
    def init(path = ".")
      Monoz::Services::InitService.new(self).call(path)
    end

    desc "bundle [COMMAND]", "Run bundle commands in all projects"
    def bundle(*command)
      return help("bundle") if command.nil? || command.first == "help"

      projects = Monoz.projects.order(:dependants)
      Monoz::Services::RunService.new(self).call(projects, "bundle", *command)

      say "The command ran successfully in all project directories without any errors.", [:green]
    end

    desc "projects", "Shows a list of projects in this repository"
    def projects
      Monoz.projects.order(:name).to_table
    end

    map "run" => "run_action"
    desc "run [COMMAND]", "Run commands in all projects"
    def run_action(*command)
      return help("run") if command.nil? || command.first == "help"

      projects = Monoz.projects.order(:dependants)
      Monoz::Services::RunService.new(self).call(projects, *command)

      say "The command ran successfully in all project directories without any errors.", [:green]
    end

    desc "version", "Get the current version of Monoz"
    def version
      say "Monoz version: #{Monoz::VERSION}"
    end
  end
end
