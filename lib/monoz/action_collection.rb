# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module Monoz
  class ActionCollection
    include Enumerable
    delegate_missing_to :@items

    def initialize
      @items = []
      populate_items
    end

    def exist?(name)
      !!find(name)
    end

    def find(name)
      @items.select { |i| i.name == name.to_s }&.first
    end

    def all
      @items
    end

    private
      def populate_items
        actions = Monoz.config.dig("actions")
        return if actions.empty?

        raise "Invalid format, actions must be a hash." unless actions.is_a?(Hash)

        actions.each do |action_name, config_raw_data|
          @items << Monoz::Action.new(action_name, config_raw_data)
        end
      end
  end
end
