# frozen_string_literal: true

require "yaml"
require "fileutils"
require "pty"
require "active_support/core_ext/array" # Import the necessary extension

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

      def failed?
        !!success?
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
        @command = []
      end

      def call(projects, *command)
        raise ArgumentError, "Missing command" if command.empty?

        @command = command
        if projects.is_a?(Monoz::ProjectCollection)
          @projects = projects.all
        elsif projects.is_a?(Monoz::Project)
          @projects = [projects]
        else
          raise "Invalid projects"
        end

        say "Running ", nil, false
        say command.join(" "), [:bold], false
        say " in #{@projects.map { |p| p.name }.to_sentence}:"

        say ""
        run_commands
        say ""

        if errors?
          say ""
          say "Error: The command ", :red
          say "#{command.join(" ")} ", [:red, :bold]
          say "failed to run in one or more project directories", [:red]
          exit(1)
        end
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

      private
        def run_commands
          @projects.each do |project|
            if spinner?
              spinner = Monoz::Spinner.new(@command.join(" "), prefix: project.name).start
            else
              say "[#{project.name}] ", [:blue, :bold], nil
              say @command.join(" ")
            end

            response = run_in_project(project, *@command)

            if response.success?
              spinner&.success! if spinner?
            else
              spinner&.error! if spinner?
              say response.output
              say "" # line break
              @errors << {
                project: project.name,
                command: @command.join(" "),
                exit_code: response.exit_code,
                output: response.output
              }
            end
          end
        end

        def spinner?
          !Monoz.verbose?
        end

        def run_in_project(project, *command)
          raise ArgumentError, "Invalid command" if command.empty?

          output = ""
          exit_status = nil

          FileUtils.chdir(project.root_path) do
            PTY.spawn(*command.map { |arg| Shellwords.escape(arg) }) do |stdout, stdin, pid|
              begin
                stdout.each do |line|
                  output += line
                  print line if Monoz.verbose?
                end
              rescue Errno::EIO
              end

              Process.wait(pid)
              exit_status = $?.exitstatus
            end
          end

          Monoz::Responses::RunServiceResponse.new(output, exit_status)
        rescue Errno::ENOENT => e
          Monoz::Responses::RunServiceResponse.new(e.message, 1)
        end
    end
  end
end
