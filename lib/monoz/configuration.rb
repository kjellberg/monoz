require "yaml"

module Monoz
  class Configuration
    attr_reader :config_file_path

    def initialize(dir_path)
      @config_file_path = find_config_file(dir_path)
      raise Monoz::Errors::ConfigurationNotFound unless @config_file_path
    end

    def contents
      @contents ||= load_config(@config_file_path) if @config_file_path
    end

    def root_path
      File.dirname @config_file_path
    end

    class << self
      def default_config
        { projects: ["apps", "gems"] }
      end
    end

    private
    def find_config_file(dir_path)
      while dir_path != "/"
        config_file_path = File.join(dir_path, "monoz.yaml")
        return config_file_path if File.exist?(config_file_path)

        dir_path = File.dirname(dir_path)
      end
    end

    def load_config(config_file_path)
      YAML.load_file(config_file_path)
    end
  end
end
