# frozen_string_literal: true

require "yaml"
require "fileutils"

module Monoz
  module Services
    class BaseService
      include Thor::Shell

      def initialize(thor_instance)
        @thor = thor_instance
      end

      class << self
        def call(path)
          new(path).call
        end
      end
    end
  end
end
