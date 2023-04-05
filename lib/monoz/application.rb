# frozen_string_literal: true

require "thor"
require "yaml"
require "fileutils"

module Monoz
  class Application < Thor
    class_option :verbose, type: :boolean, aliases: ["--tty", "-t"], default: false
    class_option :filter

    def initialize(*args)
      super
      Monoz.app = self
    end

    desc "init [PATH]", "Initialize a monozrepo at the specified PATH"
    def init(path = ".")
      Monoz::Services::InitService.new(self).call(path)
    end

    desc "bundle [COMMAND]", "Run bundle commands in all projects"
    def bundle(*command)
      return help("bundle") if command.nil? || command.first == "help"

      projects = Monoz.projects.order(:dependants)
      Monoz::Services::BundleService.new(self).link_local_gems!(projects)
      Monoz::Services::RunService.new(self).call(projects, "bundle", *command)

      say "The command ran successfully in all project directories without any errors.", [:green]
    end

    desc "link", "Link gems to local directories in development."
    def link
      say "Linking gems to local directories by setting the source directory in bundle config", [:blue, :bold]
      say "Please ensure you're not including ", :yellow
      say ".bundle/config ", [:yellow, :bold]
      say "file in your git repository by mistake", :yellow
      say ""

      Monoz::Services::BundleService.new(self).link_local_gems!(Monoz.projects)

      say "Successfully linked all gem directories without any errors.", [:green]
    end

    desc "projects", "Shows a list of projects in this repository"
    def projects
      Monoz.projects.order(:name).to_table
    end

    map "run" => "run_action"
    desc "run [COMMAND]", "Run commands in all projects"
    def run_action(*command)
      return help("run") if command.empty? || command.first == "help"

      projects = Monoz.projects.order(:dependants)
      Monoz::Services::RunService.new(self).call(projects, *command)

      say "The command ran successfully in all project directories without any errors.", [:green]
    end

    desc "version", "Get the current version of Monoz"
    def version
      say "Monoz version: #{Monoz::VERSION}"
    end

    # This method will be called when a command is not found
    desc "[ACTION]", "Custom action"
    def method_missing(action_name, *args)
      Monoz::Services::ActionService.new(self).call(action_name)
    end
  end
end
