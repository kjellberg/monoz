# frozen_string_literal: true

require_relative "monoz/version"

require "pathname"

module Monoz
  module Errors
    class ConfigurationNotFound < StandardError; end
  end

  module Cli
    autoload "Bundle", "monoz/cli/bundle"
    autoload "Inspect", "monoz/cli/inspect"
    autoload "Main", "monoz/cli/main"
  end

  autoload "Configuration", "monoz/configuration"
  autoload "Project", "monoz/project"
  autoload "ProjectCollection", "monoz/project_collection"

  class << self
    def config
      @config ||= Monoz::Configuration.new(Pathname.new(Dir.pwd))
    end

    def projects
      Monoz::ProjectCollection.new(config.root_path)
    end
  end
end
