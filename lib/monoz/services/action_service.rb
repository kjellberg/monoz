# frozen_string_literal: true

require "yaml"
require "fileutils"

module Monoz
  module Services
    class ActionService < Monoz::Services::BaseService
      def call(action)
        @action = Monoz.actions.find(action)
        say_invalid_action(action) if @action.nil?
        Monoz.verbose = true
        run_action
      end

      private
        def run_action
          say "Running Monoz action: "
          say @action.name, [:bold, :blue]

          @action.commands.each do |action_command|
            projects = Monoz.projects.filter(action_command.filter).order(:dependants)
            command = action_command.command.split(" ")
            Monoz::Services::RunService.new(self).call(projects, *command)
          end
        end

        def say_invalid_action(cmd_or_action)
          say "Error: The command or action ", :red
          say "#{cmd_or_action} ", [:red, :bold]
          say "does not exist.", [:red]
          exit(1)
        end
    end
  end
end
