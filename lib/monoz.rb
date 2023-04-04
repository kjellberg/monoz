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
    autoload "Run", "monoz/cli/run"
  end

  module Services
    autoload "BaseService", "monoz/services/base_service"
    autoload "InitService", "monoz/services/init_service"
    autoload "RunActionService", "monoz/services/run_action_service"
  end

  autoload "Configuration", "monoz/configuration"
  autoload "Project", "monoz/project"
  autoload "ProjectCollection", "monoz/project_collection"

  class << self
    def config
      @config ||= Monoz::Configuration.new(pwd)
    end

    def projects
      Monoz::ProjectCollection.new(config.root_path)
    end

    def pwd
      @pwd ||= Pathname.new(Dir.pwd)
    end

    def pwd=(value)
      @pwd = value
    end
  end
end
