# frozen_string_literal: true

module Pdadv
  class ScenarioParser
    def initialize(file_path)
      @file_path = file_path
      @lines = File.read(@file_path).split(/\r?\n/)
      reset
    end

    def reset
      @messages = []
      @result = nil
    end

    def parse
      return @result if @result

      reset
      scenario = Scenario.new
      parse_meta(scenario)
      parse_commands(scenario)

      @result = scenario
    end

    def parse_meta(scenario)
      scenario.env.base_path = File.expand_path('..', @file_path)
    end

    def parse_commands(scenario)
      @lines.each do |line|
        case line
        when %r{^//}
          nil # comment
        when /^%(?<name>[^\s]+)\s*(?<argv>.+)$/
          name = Regexp.last_match(1)
          argv = Regexp.last_match(2).to_s.split(/\s*,\s*/)
          scenario.add_command(name, argv)
        when /^#+\s(?<flag_name>.+)$/
          name = Regexp.last_match(1)
          add_message(scenario)
          scenario.enter_page(name)
        when /^-{3,}$/
          add_message(scenario)
          scenario.enter_page
        else
          @messages.push line
        end
      end

      add_message(scenario)
    end

    def add_message(scenario)
      return if @messages.empty?
      scenario.add_message(@messages.join("\n"))
      @messages = []
    end
  end
end
