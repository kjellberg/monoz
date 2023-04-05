# frozen_string_literal: true

module Monoz
  class Spinner
    include Thor::Shell

    def initialize(message, prefix: nil)
      @spinner = nil
      @message = message
      @prefix = prefix
    end

    def start
      @spinner = main
      self
    end

    def success!
      @spinner.kill
      say_formatted(" \u2713 ", [:bold, :green])
      say() # line break
    end

    def error!
      @spinner.kill
      say_formatted(" \u2717 ", [:bold, :red])
      say() # line break
    end

    private
      def reset
        say("\r", nil, false)
      end

      def say_formatted(suffix, suffix_formatting = nil)
        if @prefix != nil
          say "\r[#{@prefix}] ", [:blue, :bold], nil
          say @message, nil, false
          say suffix, suffix_formatting, false
        else
          say "\r#{@message}", nil, false
          say suffix, suffix_formatting, false
        end
      end

      def main
        spinner_count = 0

        Thread.new do
          loop do
            dots = case spinner_count % 3
                   when 0 then "."
                   when 1 then ".."
                   when 2 then "..."
            end

            say_formatted(dots)
            spinner_count += 1
            sleep(0.5)
          end
        end
      end
  end
end
