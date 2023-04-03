# frozen_string_literal: true

require "thor"
require "yaml"

module Monoz
  module Cli
    class Bundle < Thor
      default_task :install

      desc "install", "Install dependencies in all projects"
      def install
        Monoz.projects.order(:dependants).each do |project|
          say "#{project.type} ", project.text_color, false
          say "[#{project.name}] ", [:blue, :bold], false
          say "bundle install", :green
          project.run "bundle", "install"
        end
      end

      desc "update", "Update dependencies in all projects"
      def update
        Monoz.projects.order(:dependants).each do |project|
          say "#{project.type} ", project.text_color, false
          say "[#{project.name}] ", [:blue, :bold], false
          say "bundle update", :green
          project.run "bundle", "update"
        end
      end
    end
  end
end
