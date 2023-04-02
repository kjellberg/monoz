require "pathname"
require "active_support/core_ext/module/delegation"

module Monoz
  class ProjectCollection
    include Enumerable
    delegate_missing_to :@items

    def initialize(file_path)
      @items = []
      project_folders = Monoz.config.dig(:folders)

      search_paths = project_folders.map { |folder| File.join(file_path, folder) }
      
      search_paths.each do |search_path|
        Dir.glob(File.join(search_path, "*/Gemfile")).each do |gemfile_path|
          project_path = File.dirname(gemfile_path)
          project = Project.new(project_path)
          @items << project if project.valid?
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
