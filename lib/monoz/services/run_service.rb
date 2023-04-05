# frozen_string_literal: true

require "yaml"
require "fileutils"
require "open3"

module Monoz
  module Responses
    class RunServiceResponse
      attr_reader :output, :exit_code

      def initialize(output, exit_code)
        @output = output
        @exit_code = exit_code
      end

      def success?
        exit_code == 0
      end

      def error?
        exit_code == 1
      end
    end
  end

  module Services
    class RunService < Monoz::Services::BaseService
      attr_reader :errors, :warnings

      def initialize(thor_instance)
        super(thor_instance)
        @projects = nil
        @errors = []
        @warnings = []
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
        raise ArgumentError, "Missing command" if command.empty?

        if projects.is_a?(Monoz::ProjectCollection)
          @projects = projects.all
        elsif projects.is_a?(Monoz::Project)
          @projects = [projects]
        else
          raise "Invalid projects"
        end

        @projects.each do |project|
          if Monoz.tty?
            say "[#{project.name}] ", [:blue, :bold], nil
            say command.join(" ")
          else
            spinner = Monoz::Spinner.new(command.join(" "), prefix: project.name).start
          end

          response = run_commands_in_project(project, *command)

          if response.success?
            spinner&.success! unless Monoz.tty?
          else
            spinner&.error! unless Monoz.tty?
            say response.output
            say "" # line break
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
          raise ArgumentError, "Invalid command" if command.empty?

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

          Monoz::Responses::RunServiceResponse.new(output, exit_status)
        rescue Errno::ENOENT => e
          Monoz::Responses::RunServiceResponse.new(e.message, 1)
        end
    end
  end
end
