# frozen_string_literal: true

require "thor"
require "yaml"

module Monoz
  module Cli
    class Inspect < Thor
      default_task :all

      desc "all", "Returns a list of all projects in this monozrepo"
      def all
        say "Project \tType \tGem Name \tDependants", :bold
        Monoz.projects.order(:name).each do |project|
          say "#{project.name} \t", nil, false
          say "#{project.type} \t", project.text_color, false
          say "#{project.is_gem? ? project.gem_name : "\t" } \t", nil, false
          say "#{project.dependants.join(", ")}"
        end
      end

      desc "apps", "Returns a list of apps in this monozrepo"
      def apps
        say "Project \tType \tDependants", :bold
        Monoz.projects.order(:name).filter(:apps).each do |project|
          say "#{project.name} \t", nil, false
          say "#{project.type} \t", project.text_color, false
          say "#{project.dependants.join(", ")}"
        end
      end

      desc "gems", "Returns a list of gems in this monozrepo"
      def gems
        say "Project \tType \tGem Name \tDependants", :bold
        Monoz.projects.filter(:gems).order(:name).each do |project|
          say "#{project.name} \t", nil, false
          say "#{project.type} \t", project.text_color, false
          say "#{project.is_gem? ? project.gem_name : "\t" } \t", nil, false
          say "#{project.dependants.join(", ")}"
        end
      end
    end
  end
end
