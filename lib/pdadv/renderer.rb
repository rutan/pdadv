# frozen_string_literal: true

require 'prawn'
require 'cgi'

module Pdadv
  class Renderer
    include Prawn::View

    def initialize(scenario)
      @scenario = scenario
    end

    attr_reader :scenario

    def document
      @document ||= Prawn::Document.new(
        page_size: scenario.env['Size'].map(&:to_i),
        margin: 0
      )
    end

    def render
      font(scenario.asset_path(scenario.env['Font']))
      create_pages
      scenario.screens.each.with_index do |screen, i|
        go_to_page(i + 1)
        render_page(screen)
      end
    end

    private

    def create_pages
      scenario.screens.each.with_index do |_, i|
        start_new_page if i > 0
      end
    end

    def render_page(screen)
      add_dest(screen.name, dest_xyz(0, 0))

      draw_back(screen)
      draw_characters(screen)
      draw_message_window(screen)
      draw_frame
      draw_message_body(screen)
    end

    def draw_back(screen)
      return unless screen.back
      float do
        image(
          scenario.asset_path(screen.back.path),
          position: :center,
          vposition: :center,
          fit: scenario.env['Size']
        )
      end
    end

    def draw_characters(screen)
      screen.actors.each.with_index do |actor, i|
        next unless actor

        float do
          x = (i + 1) * scenario.env['Size'][0] / 7
          draw_character_image(actor, x)
        end
      end
    end

    def draw_character_image(actor, base_x)
      image(
        scenario.asset_path(actor.path),
        at: [base_x + actor.x - actor.width / 2, -(actor.y - actor.height)]
      )
    end

    def draw_message_window(screen)
      return if scenario.env['MessageWindow'].empty?
      return if screen.message.empty?

      float do
        image(
          scenario.asset_path(scenario.env['MessageWindow']),
          position: :center,
          vposition: :bottom
        )
      end
    end

    def draw_message_body(screen)
      return create_large_next_link if screen.message.empty?

      float do
        message_window_box do
          text screen.format_message(scenario), draw_message_options
        end
      end
    end

    def create_large_next_link
      target_page = state.pages[page_number]
      return unless target_page
      @document.link_annotation(
        [bounds.absolute_left, bounds.absolute_bottom, bounds.absolute_right, bounds.absolute_top],
        Border: [0, 0, 0],
        Dest: @document.dest_xyz(0, 0, nil, target_page)
      )
    end

    def message_window_box
      x, y, w, h = scenario.env['MessageArea']
      y = scenario.env['Size'][1] - y
      bounding_box([x, y], width: w, height: h) do
        yield
      end
    end

    def draw_message_options
      {
        color: scenario.env['TextColor'].delete('#'),
        size: scenario.env['TextSize'],
        leading: (scenario.env['TextSize'] * 0.5),
        inline_format: true
      }
    end

    def draw_frame
      return if scenario.env['Frame'].empty?

      float do
        image(
          scenario.asset_path(scenario.env['Frame']),
          position: :center,
          vposition: :center
        )
      end
    end
  end
end
