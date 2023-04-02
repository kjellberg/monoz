# frozen_string_literal: true

module Monoz
  class Project
    attr_reader :name, :root_path, :gemspec, :type
    
    def initialize(root_path)
      @root_path = root_path
      @gemspec = gemspec_path
      @gemfile = gemfile_path
  
      @name = File.basename(root_path)
      @type = is_gem? ? "gem" : "app"
    end

    def gemspec_path
      Dir.glob(File.join(@root_path, "*.gemspec")).first
    end

    def gemfile_path
      Dir.glob(File.join(@root_path, "Gemfile")).first
    end

    def is_gem?
      !@gemspec.nil?
    end
  end
end
