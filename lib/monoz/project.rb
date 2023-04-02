# frozen_string_literal: true

module Monoz
  class Project
    attr_reader :name, :root_path, :gemspec, :type
    
    def initialize(name, root_path, gemspec)
      @name = name
      @root_path = root_path
      @gemspec = gemspec || {}
      @type = is_gem? ? "gem" : "app"
    end

    def is_gem?
      @gemspec != {}
    end
  end
end
