# frozen_string_literal: true

require "yaml"
require "fileutils"

module Monoz
  module Services
    class RunActionService < Monoz::Services::BaseService
      def call(keys = nil)
        action = Monoz.config.dig("actions", *keys)

        if action.nil?
          say "Invalid action: ", :red, false
          say keys, [:red, :bold]
          exit 0
        end

        pp action
        # Monoz.projects.order(:dependants).each do |project|
        #   project.run "ls"
        # end
      end
    end
  end
end
