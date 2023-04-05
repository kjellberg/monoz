# frozen_string_literal: true

require "pathname"
require "active_support/core_ext/module/delegation"
require "terminal-table"

module Monoz
  class ProjectCollection
    include Enumerable
    delegate_missing_to :@items

    def initialize(file_path)
      @items = []
      project_folders = Monoz.folders

      search_paths = project_folders.map { |folder| File.join(file_path, folder) }

      search_paths.each do |search_path|
        Dir.glob(File.join(search_path, "*/Gemfile")).each do |gemfile_path|
          project_path = File.dirname(gemfile_path)
          project = Project.new(project_path)
          if project.valid?
            @items << project
            refresh_dependants(project)
          end
        end
      end
    end

    def exist?(name)
      !!find(name)
    end

    def find(name)
      @items.select { |i| i.name == name }&.first
    end

    def all
      @items
    end

    def order(key)
      if key.to_sym == :name
        @items = order_by_name
        self
      elsif key.to_sym == :dependants
        @items = order_by_dependants
        self
      else
        raise "Invalid order key: #{key}"
      end
    end

    def filter(filters = [])
      if filters.is_a?(String)
        filters = filters.split(",").map(&:strip)
      end
      if filters.empty?
        @items = []
        return self
      end
      filtered_items = []
      filters.each do |filter|
        if filter == "gems"
          filtered_items += @items.select { |i| i.type == "gem" }
        elsif filter == "apps"
          filtered_items += @items.select { |i| i.type == "app" }
        else
          project = find(filter)
          if project
            filtered_items << project
          else
            raise Monoz::Errors::StandardError.new("Invalid key: #{filter}")
          end
        end
      end
      @items = filtered_items.uniq
      self
    end

    def to_table
      rows = []
      @items.each do |project|
        rows << [project.name, project.type, project.gem_name, project.frameworks.join(", "), project.dependants.join(", ")]
      end
      table = Terminal::Table.new(
        headings: ["Project", "Type", "Gem name", "Found Framework(s)", "Dependants"],
        rows: rows,
        style: { padding_left: 2, padding_right: 2, border_i: "o" }
      )
      puts table
    end

    private
      def refresh_dependants(project)
        @items.each do |other_project|
          next if other_project == project
          other_project.dependencies.each do |dep_name, _|
            if dep_name == project.gem_name
              project.dependants << other_project.name
              break
            end
          end
        end
      end

      def order_by_name
        @items.sort_by(&:name)
      end

      def order_by_dependants
        sorted_items = []
        items = @items.dup # make a copy of items to avoid modifying @items
        dependants = Hash.new { |h, k| h[k] = [] }

        # build a hash of dependants for each project
        items.each do |project|
          project.dependants.each do |dependant|
            dependants[dependant] << project.name
          end
        end

        # perform a topological sort
        until items.empty?
          no_dependencies = items.select { |project| dependants[project.name].empty? }
          raise "Circular dependency detected" if no_dependencies.empty?
          sorted_items.concat(no_dependencies)
          no_dependencies.each do |project|
            items.delete(project)
            dependants.each { |_, v| v.delete(project.name) }
          end
        end

        sorted_items
      end
  end
end
