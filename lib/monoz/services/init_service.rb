# frozen_string_literal: true

require "yaml"
require "fileutils"

module Monoz
  module Services
    class InitService < Monoz::Services::BaseService
      def call(path)
        config_file_path = File.join(File.expand_path(path), "monoz.yml")
        project_dir = File.dirname(config_file_path)

        if File.exist?(config_file_path)
          @thor.say "Error: monoz.yaml already exists in #{config_file_path}", :red
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

        @thor.say "Successfully initialized Monoz in #{project_dir}", :green
      end
    end
  end
end
