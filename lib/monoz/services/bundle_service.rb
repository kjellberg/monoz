# frozen_string_literal: true

require "yaml"
require "fileutils"
require "active_support"

module Monoz
  module Services
    class BundleService < Monoz::Services::BaseService
      def call(*command)
        Monoz.projects.order(:dependants).each do |project|
          say "[#{project.name}] ", [:blue, :bold], false
          say("bundle #{command.join(" ")}".strip, :green)
          project.run "bundle", *command
        end
      end
    end
  end
end
