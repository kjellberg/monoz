# frozen_string_literal: true

require "yaml"
require "fileutils"

module Monoz
  module Services
    class RunService < Monoz::Services::BaseService
      attr_reader :errors, :warnings

      def initialize(thor_instance)
        @projects = nil
        @errors = []
        @warnings = []
        super(thor_instance)
      end

      def success?
        !errors? && !warnings?
      end

      def errors?
        @errors.any?
      end

      def warnings?
        @warnings.any?
      end

      def call(projects, *command)
        raise ArgumentError.new("Missing command") if command.empty?

        if projects.is_a?(Monoz::ProjectCollection)
          @projects = projects.all
        elsif projects.is_a?(Monoz::Project)
          @projects = [projects]
        else
          raise "Invalid projects"
        end

        @projects.each do |project|
          say "#{project.name}: ", [:bold, :blue]
          say "#{command.join(" ")} "

          response = run_commands_in_project(project, *command)

          if response.success?
            say "\u2713", [:green, :bold] # Checkmark symbol in green and bold
          else
            say "\u2717", :red # Cross symbol in red
            say response.output
            say ""
            @errors << {
              project: project.name,
              command: command.join(" "),
              exit_code: response.exit_code,
              output: response.output
            }
          end
        end

        self
      end

      private
        def run_commands_in_project(project, *command)
          raise ArgumentError.new("Invalid command") if command.empty?

          FileUtils.chdir(project.root_path) do
            output, status = Open3.capture2e(*command.map { |arg| Shellwords.escape(arg) })
            return Monoz::Responses::CaptureRunResponse.new(output, status.exitstatus)
          end
        end
    end
  end
end