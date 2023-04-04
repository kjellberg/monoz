# frozen_string_literal: true

require "spec_helper"

RSpec.describe Monoz::ProjectCollection do
  let(:projects) { Monoz.projects.dup }

  before { use_example_repo("ruby-on-rails") }

  describe "#exist?" do
    context "when project exists" do
      it "returns true" do
        expect(projects.exist?("example-com")).to be_truthy
      end
    end

    context "when project does not exist" do
      it "returns false" do
        expect(projects.exist?("example-net")).to be_falsey
      end
    end
  end

  describe "#find" do
    context "when project exists" do
      it "returns the project" do
        project = projects.find("example-com")
        expect(project).to be_a(Monoz::Project)
        expect(project.name).to eq("example-com")
      end
    end

    context "when project does not exist" do
      it "returns nil" do
        expect(projects.find("nonexistent")).to be_nil
      end
    end
  end

  describe "#all" do
    it "returns all projects" do
      expect(projects.all.length).to eq(2)
      expect(projects.all).to all(be_a(Monoz::Project))
    end
  end

  describe "#order" do
    context "when key is :name" do
      it "orders projects by name" do
        projects.order(:name)
        expect(projects.all.map(&:name)).to eq(["example-com", "example-core"])
      end
    end

    context "when key is :dependants" do
      it "orders projects by number of dependants" do
        projects.order(:dependants)
        expect(projects.all.map(&:name)).to eq(["example-com", "example-core"])
      end
    end

    context "when key is invalid" do
      it "raises an error" do
        expect { projects.order(:invalid_key) }.to raise_error("Invalid order key: invalid_key")
      end
    end
  end

  describe "#filter" do
    context "when key is apps" do
      it "filters by apps" do
        projects.filter("apps")
        expect(projects.all.map(&:type)).to all(eq("app"))
      end
    end

    context "when key is gems" do
      it "filters by gems" do
        projects.filter("gems")
        expect(projects.all.map(&:type)).to all(eq("gem"))
      end
    end

    context "when key is gems,apps" do
      it "filters by gems" do
        projects.filter("gems,apps")
        expect(projects.count).to eq(2)
      end
    end

    context "when key is gems + an id" do
      it "filters by gems" do
        projects.filter("gems,example-com")
        expect(projects.count).to eq(2)
      end
    end

    context "when key is an id" do
      it "filters by gems" do
        projects.filter("example-core")
        expect(projects.first.name).to eq("example-core")
      end
    end

    context "when key is invalid" do
      it "raises error on invalid key" do
        expect { projects.filter("invalid-key") }.to raise_error
      end
    end
  end
end
