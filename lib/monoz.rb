# frozen_string_literal: true

require_relative "monoz/version"

require "pathname"
require "shellwords"

module Monoz
  module Errors
    class ConfigurationNotFound < StandardError; end
  end

  module Responses
    class CaptureRunResponse
      attr_reader :output, :exit_code

      def initialize(output, exit_code)
        @output = output
        @exit_code = exit_code
      end

      def success?
        exit_code == 0
      end

      def error?
        exit_code == 1
      end
    end
  end

  module Services
    autoload "BaseService", "monoz/services/base_service"
    autoload "InitService", "monoz/services/init_service"
    autoload "RunService", "monoz/services/run_service"
  end

  autoload "Application", "monoz/application"
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
