# frozen_string_literal: true

require 'cgi'

module Pdadv
  class Screen
    def initialize(name = nil)
      @name = name || "id-#{rand(999_999_999)}"
      @back = nil
      @actors = []
      @message = ''
    end

    attr_accessor :name, :back, :message
    attr_reader :actors

    def format_message(scenario)
      return '' if message.empty?

      text = CGI.escape_html(message)
      text = create_link(scenario, text)

      text
    end

    private

    def create_link(scenario, text)
      text.gsub(/\[(?<name>[^\]]+)\](\((?<to>[^\)]+)\))?/) do
        text = Regexp.last_match(1)
        to = Regexp.last_match(2)
        case to
        when nil
          create_next_page_link(scenario, text)
        when /^https?:/
          create_web_link(text, to)
        else
          create_page_link(scenario, text, to)
        end
      end
    end

    def create_next_page_link(scenario, text)
      i = scenario.screens.find_index { |s| s.name == name } || 0
      "<u><link anchor=\"##{i + 1}\">#{text}</link></u>"
    end

    def create_web_link(text, url)
      "<u><link href=\"##{url}\">#{text}</link></u>"
    end

    def create_page_link(scenario, text, dest_name)
      i = scenario.screens.find_index { |s| s.name == dest_name } || 0
      "<u><link anchor=\"##{i}\">#{text}</link></u>"
    end
  end
end
