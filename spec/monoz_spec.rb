# frozen_string_literal: true

require "spec_helper"

RSpec.describe Monoz do
  it "has a version number" do
    expect(Monoz::VERSION).not_to be nil
  end

  describe "#pwd" do
    it "can override working directory" do
      Monoz.pwd = Pathname.new("/tmp/test")
      expect(Monoz.pwd).to eq(Pathname.new("/tmp/test"))
    end
  end

  describe "#config" do
    it "returns a Configuration instance" do
      use_example_repo("ruby-on-rails")
      expect(Monoz.config).to be_an_instance_of(Monoz::Configuration)
    end

    it "returns the same instance each time" do
      use_example_repo("ruby-on-rails")
      expect(Monoz.config).to be(Monoz.config)
    end
  end

  describe "#projects" do
    it "returns a ProjectCollection instance" do
      expect(Monoz.projects).to be_an_instance_of(Monoz::ProjectCollection)
    end
  end
end
