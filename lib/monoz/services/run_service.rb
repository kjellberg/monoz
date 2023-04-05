# frozen_string_literal: true

require "yaml"
require "fileutils"
require "open3"

module Monoz
  class Spinner
    include Thor::Shell

    def initialize(message, prefix: nil)
      @spinner = nil
      @message = message
      @prefix = prefix
    end

    def start
      @spinner = main
      self
    end

    def success!
      @spinner.kill
      say_formatted(" \u2713 ", [:bold, :green])
      say() # line break
    end

    def error!
      @spinner.kill
      say_formatted(" \u2717 ", [:bold, :red])
      say() # line break
    end

    private
      def reset
        say("\r", nil, false)
      end

      def say_formatted(suffix, suffix_formatting = nil)
        if @prefix != nil
          say "\r[#{@prefix}] ", [:blue, :bold], nil
          say @message, nil, false
          say suffix, suffix_formatting, false
        else
          say "\r#{@message}", nil, false
          say suffix, suffix_formatting, false
        end
      end

      def main
        spinner_count = 0

        Thread.new do
          loop do
            dots = case spinner_count % 3
                   when 0 then "."
                   when 1 then ".."
                   when 2 then "..."
            end

            say_formatted(dots)
            spinner_count += 1
            sleep(0.5)
          end
        end
      end
  end

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
          # say "#{project.name}: ", [:bold, :blue]
          # Monoz.tty? ? say(command.join(" ")) : say("#{command.join(" ")} ")

          if Monoz.tty?
            say "[#{project.name}] ", [:blue, :bold], nil
            say command.join(" ")
          else
            spinner = Monoz::Spinner.new(command.join(" "), prefix: project.name).start
          end

          response = run_commands_in_project(project, *command)

          if response.success?
            spinner.success! unless Monoz.tty?
          else
            spinner.error! unless Monoz.tty?
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
