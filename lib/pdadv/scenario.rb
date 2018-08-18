# frozen_string_literal: true

require 'fastimage'

module Pdadv
  class Scenario
    def initialize
      @env = Pdadv::Environment.new
      @screens = []
      @registered_images = {}
    end
    attr_reader :env, :screens

    def asset_path(path)
      File.expand_path(path, @env.base_path)
    end

    def last_screen
      enter_page if screens.empty?
      @screens.last
    end

    def enter_page(name = nil)
      @screens.push(Pdadv::Screen.new(name))
    end

    def add_message(message)
      return if message.strip.empty?
      last_screen.message = message.strip
    end

    def add_command(name, argv = [])
      case name.downcase
      when 'setglobal'
        add_set_global_command(argv)
      when 'register'
        add_register_command(argv)
      when 'back'
        add_back_command(argv)
      when 'show'
        add_show_command(argv)
      else
        puts "[unknown command]\t#{name}"
      end
    end

    private

    def add_set_global_command(argv)
      key, *values = argv
      values = values.map(&:to_i) if values.all? { |n| n.match(/\A\d+\z/) }
      @env[key] = values.size > 1 ? values : values.first
    end

    def add_register_command(argv)
      name, path, x, y = argv
      w, h = FastImage.size(asset_path(path))
      @registered_images[name] = Pdadv::Entities::ImageEntity.new(
        path: path,
        x: x || 0,
        y: y || 0,
        width: w,
        height: h
      )
    end

    def add_back_command(argv)
      last_screen.back = @registered_images[argv.first]
    end

    def add_show_command(argv)
      i, name = argv
      last_screen.actors[i.to_i] = @registered_images[name]
    end
  end
end
