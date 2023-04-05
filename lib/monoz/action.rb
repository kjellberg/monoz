# frozen_string_literal: true

module Monoz
  class ActionCommand
    attr_reader :filter, :command
    def initialize(filter, command)
      @filter = filter
      @command = command
    end
  end

  class Action
    attr_reader :name, :commands

    def initialize(name, raw_commands)
      @name = name
      @commands = []
      parse_commands(raw_commands)
    end

    private
      def parse_commands(raw_commands)
        raw_commands.each do |command|
          @commands << Monoz::ActionCommand.new(command.dig("in"), command.dig("run"))
        end
      end
  end
end
