require "pathname"
require "active_support/core_ext/module/delegation"

module Monoz
  class ProjectCollection
    include Enumerable
    delegate_missing_to :@items

    def initialize(file_path)
      @items = []
      search_paths = [
        File.join(file_path, "apps"),
        File.join(file_path, "gems")
      ]

      search_paths.each do |search_path|
        Dir.glob(File.join(search_path, "*/Gemfile")).each do |gemfile_path|
          project_path = File.dirname(gemfile_path)
          gemspec_path = Dir.glob(File.join(project_path, "*.gemspec")).first
          project = Project.new(File.basename(project_path), project_path, gemspec_path)
          @items << project
        end
      end
    end

    def exist?(id)
      !!_find(id)
    end

    def _find(id)
      @items.select { |i| i.id == id }&.first
    end
  end
end
