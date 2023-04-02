# frozen_string_literal: true

require "thor"
require "yaml"
 
module Monoz
  module Cli
    class Main < Thor
      desc "init [PATH]", "Initialize your monorepo at the specified PATH"
      def init(path = ".")
        config_file_path = File.join(File.expand_path(path), "monoz.yaml")

        if File.exist?(config_file_path)
          say "Error: monoz.yaml already exists in #{config_file_path}", :red
          return
        end

        FileUtils.mkdir_p(File.dirname(config_file_path))

        File.write(config_file_path, Monoz::Configuration.default_config.to_yaml)

        say "Created a monoz.yaml file in #{config_file_path}", :green
      end

      desc "inspect", "Inspect your Monozrepo"
      def inspect
        projects = Monoz::ProjectCollection.new(Monoz.config.root_path)

        pp projects
        exit(0)

        say "Project \tType \tFile path", :bold
        projects.each do |project|
          say "#{project.name} \t", nil, false
          say "#{project.type} \t", (project.type == "app" ? :blue : :green), false
          say "#{project.root_path}"
        end
      end

      desc "version", "Get the current version of Monoz"
      def version
        say "Monoz version: #{Monoz::VERSION}"
      end
    end
  end
end
