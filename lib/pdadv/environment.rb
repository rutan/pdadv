# frozen_string_literal: true

module Pdadv
  class Environment
    def initialize
      @base_path = ''
      @settings = {
        'Font' => '',
        'TextColor' => '#ffffff',
        'TextSize' => '40',
        'Size' => [1280, 960],
        'MessageWindow' => nil,
        'MessageArea' => [0, 0, 1280, 960],
        'Frame' => nil
      }
    end
    attr_accessor :base_path

    def [](key)
      @settings[key.to_s]
    end

    def []=(key, value)
      key = key.to_s
      raise "unknown global env: #{key}" unless @settings.key?(key)
      @settings[key] = value
    end
  end
end
