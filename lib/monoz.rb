# frozen_string_literal: true

require_relative "monoz/version"

require "pathname"
require "shellwords"

module Monoz
  module Errors
    class StandardError < StandardError; end
    class ConfigurationNotFound < StandardError; end
  end

  module Services
    autoload "ActionService", "monoz/services/action_service"
    autoload "BaseService", "monoz/services/base_service"
    autoload "BundleService", "monoz/services/bundle_service"
    autoload "InitService", "monoz/services/init_service"
    autoload "RunService", "monoz/services/run_service"
  end

  autoload "Action", "monoz/action"
  autoload "ActionCollection", "monoz/action_collection"
  autoload "Application", "monoz/application"
  autoload "Configuration", "monoz/configuration"
  autoload "Project", "monoz/project"
  autoload "ProjectCollection", "monoz/project_collection"
  autoload "Spinner", "monoz/spinner"

  class << self
    def app
      @app
    end

    def app=(value)
      @app = value
    end

    def config
      @config ||= Monoz::Configuration.new(pwd)
    end

    def actions
      @actions ||= Monoz::ActionCollection.new
    end

    def options
      @app&.options
    end

    def folders
      config.dig("folders") || ["apps", "gems"]
    end

    def verbose?
      @verbose ||= Monoz.options.dig("verbose") == true
    end

    def verbose=(value)
      @verbose = value
    end

    def projects
      filter = Monoz.options&.dig("filter")
      projects = Monoz::ProjectCollection.new(config.root_path)
      projects = projects.filter(filter) unless filter.nil?

      projects
    end

    def pwd
      @pwd ||= Pathname.new(Dir.pwd)
    end

    def pwd=(value)
      @pwd = value
    end
  end
end
