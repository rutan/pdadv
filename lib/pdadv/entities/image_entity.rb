# frozen_string_literal: true

module Pdadv
  module Entities
    class ImageEntity
      def initialize(params = {})
        @path = params[:path].to_s
        @x = params[:x].to_i
        @y = params[:y].to_i
        @width = params[:width].to_i
        @height = params[:height].to_i
      end
      attr_reader :path, :x, :y, :width, :height
    end
  end
end
