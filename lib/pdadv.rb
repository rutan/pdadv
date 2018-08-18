# frozen_string_literal: true

require 'prawn'

require 'pdadv/version'
require 'pdadv/entities/image_entity'
require 'pdadv/cli'
require 'pdadv/environment'
require 'pdadv/renderer'
require 'pdadv/scenario'
require 'pdadv/scenario_parser'
require 'pdadv/screen'

module Prawn
  module Text
    module Formatted
      class Box
        alias upstream_draw_fragment_overlay_anchor draw_fragment_overlay_anchor
        def draw_fragment_overlay_anchor(fragment)
          return unless fragment.anchor

          if /\A#\d+\z/.match?(fragment.anchor.to_s)
            i = fragment.anchor.sub('#', '').to_i
            box = fragment.absolute_bounding_box
            page = @document.state.pages[i]
            if page
              @document.link_annotation(
                box,
                Border: [0, 0, 0],
                Dest: @document.dest_xyz(0, 0, nil, page)
              )
            end
          else
            upstream_draw_fragment_overlay_anchor(fragment)
          end
        end
      end
    end
  end
end
