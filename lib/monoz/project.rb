# frozen_string_literal: true

module Monoz
  class Project
    attr_reader :name, :root_path, :gemspec, :type, :dependencies, :gem_name, :dependants

    def initialize(root_path)
      @root_path = root_path

      parse_project_files
      parse_dependencies

      setup_instance_variables
    end

    def is_gem?
      !gemspec_path.nil?
    end

    def valid?
      @root_path != nil && gemfile_path != nil
    end

    def text_color
      is_gem? ? :green : :blue
    end

    def test_frameworks
      frameworks = []

      rspec_files = Dir.glob(File.join(@root_path, "**/*_spec.rb"))
      if !rspec_files.empty?
        frameworks << "rspec"
      end

      minitest_files = Dir.glob(File.join(@root_path, "test/**/*_test.rb"))
      if !minitest_files.empty?
        frameworks << "minitest"
      end

      frameworks
    end

    private
      def parse_project_files
        @gemspec = parse_gemspec
      end

      def parse_dependencies
        @dependencies = gem_dependencies
      end

      def parse_gemspec
        return nil unless (gemspec_file = gemspec_path) && File.exist?(gemspec_file)

        spec = Gem::Specification.load(gemspec_file)
        {
          name: spec.name,
          version: spec.version.to_s
        }
      end

      def setup_instance_variables
        @name = File.basename(root_path)
        @gem_name = @gemspec.dig(:name) if is_gem?
        @type = is_gem? ? "gem" : "app"
        @test_frameworks =
        @dependants = []
      end

      def gemspec_path
        Dir.glob(File.join(@root_path, "*.gemspec")).first
      end

      def gemfile_path
        Dir.glob(File.join(@root_path, "Gemfile")).first
      end

      def gem_dependencies
        dependencies = {}

        # Check if a Gemfile exists
        if (gemfile = gemfile_path) && File.exist?(gemfile)
          gemfile_content = File.read(gemfile)

          # Use regex to find all gem entries
          gem_entries = gemfile_content.scan(/gem\s+['"]([^'"]+)['"](?:,\s*['"]([^'"]+)['"])?(?:,\s*['"]([^'"]+)['"])?/)

          # Add each gem and its version to the hash
          gem_entries.each do |gem_entry|
            gem_name = gem_entry[0]
            version_spec = gem_entry[1] || ""
            dependencies[gem_name] = version_spec
          end
        end

        # Check if a gemspec exists
        if (gemspec_file = gemspec_path) && File.exist?(gemspec_file)
          spec = Gem::Specification.load(gemspec_file)
          spec.dependencies.each do |dep|
            dependencies[dep.name] = dep.requirement.to_s
          end
        end

        dependencies
      end

    public

    # Update dependants of this project based on other projects in the collection
    def update_dependants(collection)
      collection.each do |project|
        if project.dependencies.key?(name)
          project.dependants << self
        end
      end
    end
  end
end
