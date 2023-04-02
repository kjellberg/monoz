require "pathname"

module Monoz
  class ProjectCollection
    attr_reader :all

    def initialize(file_path)
      @all = []
      search_paths = [
        File.join(file_path, "apps"),
        File.join(file_path, "gems")
      ]

      search_paths.each do |search_path|
        Dir.glob(File.join(search_path, "*/Gemfile")).each do |gemfile_path|
          project_path = File.dirname(gemfile_path)
          gemspec_path = Dir.glob(File.join(project_path, "*.gemspec")).first
          project = Project.new(File.basename(project_path), project_path, gemspec_path)
          @all << project
        end
      end
    end
  end
end
