# frozen_string_literal: true

require 'optparse'

module Pdadv
  class CLI
    def initialize(argv)
      @options = {
        output: 'output.pdf'
      }

      opt = OptionParser.new
      opt.on('-o VAL') { |n| @options[:output] = n }
      @scenario_name, = opt.parse(argv)
    end

    def run
      scenario = Pdadv::ScenarioParser.new(@scenario_name).parse

      renderer = Pdadv::Renderer.new(scenario)
      renderer.render
      renderer.save_as(@options[:output])
    end

    class << self
      def run!(argv)
        new(argv).run
      end
    end
  end
end
