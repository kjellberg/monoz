# frozen_string_literal: true

module Monoz
  module Services
    class BundleService < Monoz::Services::BaseService
      def link_local_gems!(projects)
        Monoz.projects.filter("gems").each do |gem|
          command = "monoz bundle config local.#{gem.gem_name} #{gem.root_path}"
          Monoz::Services::RunService.new(self).call(projects, *command.split(" "))
        end
      end
    end
  end
end
