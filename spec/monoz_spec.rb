# frozen_string_literal: true

require "spec_helper"

def set_project(example_name)
  Monoz.pwd = File.expand_path("../examples/#{example_name}", __dir__)
end

RSpec.describe Monoz do
  it "has a version number" do
    expect(Monoz::VERSION).not_to be nil
  end

  describe ".pwd" do
    it "returns the current working directory" do
      expect(Monoz.pwd).to eq(Pathname.new(Dir.pwd))
    end

    it "can override working directory" do
      Monoz.pwd = Pathname.new("/tmp/test")
      expect(Monoz.pwd).to eq(Pathname.new("/tmp/test"))
    end
  end

  describe ".config" do
    it "returns a Configuration instance" do
      set_project("ruby-on-rails")
      expect(Monoz.config).to be_an_instance_of(Monoz::Configuration)
    end

    it "returns the same instance each time" do
      set_project("ruby-on-rails")
      expect(Monoz.config).to be(Monoz.config)
    end
  end

  describe ".projects" do
    it "returns a ProjectCollection instance" do
      expect(Monoz.projects).to be_an_instance_of(Monoz::ProjectCollection)
    end
  end
end
