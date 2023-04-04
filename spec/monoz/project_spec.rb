# frozen_string_literal: true

require "spec_helper"

RSpec.describe Monoz::Project do
  let(:projects) { Monoz.projects }
  let(:project) { projects.find("example-com") }

  before { use_example_repo("ruby-on-rails") }

  it "returns correct root path" do
    expect(project.root_path).to eq(File.expand_path("../../examples/ruby-on-rails/apps/example-com", __dir__))
  end

  describe "#find" do
    it "can initialize a project" do
      expect(project).to be_an_instance_of(Monoz::Project)
    end
  end

  describe "#type" do
    it "returns app type for apps" do
      expect(project.type).to eq("app")
    end

    it "returns gem type for gems" do
      expect(projects.find("example-core").type).to eq("gem")
    end
  end

  describe "#is_gem?" do
    it "returns false for apps" do
      expect(project.is_gem?).to eq(false)
    end

    it "returns true for gems" do
      expect(projects.find("example-core").is_gem?).to eq(true)
    end
  end

  describe "#frameworks" do
    it "can find rspec by searching for rspec files" do
      project = projects.find("example-core")
      expect(project.frameworks).to eq(["rspec"])
    end

    it "can find minitest by searching for minitest files" do
      expect(project.frameworks).to eq(["minitest"])
    end
  end

  describe "#dependencies" do
    it "can parse dependencies from Gemfile" do
      expect(project.dependencies.count).to eq(7)
      expect(project.dependencies["sqlite3"]).to eq("~> 1.4")
    end

    it "can parse dependencies from Gemfile and gemspec" do
      project = projects.find("example-core")
      expect(project.dependencies.count).to eq(4)
      expect(project.dependencies["rails"]).to eq("~> 7.0.4")
    end
  end
end
