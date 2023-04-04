require "yaml"
require "active_support/core_ext/module/delegation"

module Monoz
  class Configuration
    attr_reader :config_file_path
    delegate_missing_to :@contents

    def initialize(project_path)
      @config_file_path = find_config_file(project_path)
      raise Monoz::Errors::ConfigurationNotFound.new("Configuration not found at: #{project_path}") unless @config_file_path
      @contents = load_config(@config_file_path) || {}
    end

    def contents
      @contents ||= load_config(@config_file_path) if @config_file_path
    end

    def root_path
      File.dirname @config_file_path
    end

    class << self
      def default_config
        { "folders" => ["apps", "gems"] }
      end
    end

    private
    def find_config_file(dir_path)
      while dir_path != "/"
        config_file_path = File.join(dir_path, "monoz.yml")
        return config_file_path if File.exist?(config_file_path)

        dir_path = File.dirname(dir_path)
      end
    end

    def load_config(config_file_path)
      YAML.load_file(config_file_path)
    end
  end
end
