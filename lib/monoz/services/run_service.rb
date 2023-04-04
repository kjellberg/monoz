# frozen_string_literal: true

require "yaml"
require "fileutils"
require "open3"

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
          Monoz.tty? ? say(command.join(" ")) : say("#{command.join(" ")} ")

          response = run_commands_in_project(project, *command)

          if response.success?
            say "\u2713", [:green, :bold] unless Monoz.tty? # Checkmark symbol in green and bold
          else
            say "\u2717", [:red, :bold] unless Monoz.tty? # Cross symbol in red
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

        say ""

        if errors?
          say "Error: The command ", :red
          say "#{command.join(" ")} ", [:red, :bold]
          say "failed to run in one or more project directories", [:red]
          exit(1)
        end
      end

      private
        def run_commands_in_project(project, *command)
          raise ArgumentError.new("Invalid command") if command.empty?

          output = ""
          exit_status = nil

          FileUtils.chdir(project.root_path) do
            if Monoz.tty?
              Open3.popen2e(*command.map { |arg| Shellwords.escape(arg) }) do |stdin, stdout_err, wait_thr|
                while line = stdout_err.gets
                  output += line
                  print line
                end

                exit_status = wait_thr.value.exitstatus
              end

              say ""
            else
              output, status = Open3.capture2e(*command.map { |arg| Shellwords.escape(arg) })
              exit_status = status.exitstatus
            end
          end

          return Monoz::Responses::CaptureRunResponse.new(output, exit_status)
        end
    end
  end
end
