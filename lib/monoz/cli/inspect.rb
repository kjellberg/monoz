# frozen_string_literal: true

require "thor"
require "yaml"

module Monoz
  module Cli
    class Inspect < Thor
      default_task :all

      desc "all", "Returns a list of all projects in this monozrepo"
      def all
        Monoz.projects.order(:name).to_table
      end

      desc "apps", "Returns a list of apps in this monozrepo"
      def apps
        Monoz.projects.order(:name).filter(:apps).to_table
      end

      desc "gems", "Returns a list of gems in this monozrepo"
      def gems
        Monoz.projects.filter(:gems).order(:name).to_table
      end
    end
  end
end
