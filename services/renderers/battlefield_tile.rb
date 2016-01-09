module Renderer
end

class Renderer::BattlefieldTile
  include Drawable

  WIDTH = 64
  HEIGHT = 64

  attr_reader :mouse

  def initialize(tile, options)
    @tile = tile
    @viewport = options[:viewport]
    @mouse = false

    raise ArgumentError.new("Invalid arguments for Rendered::BattlefieldTile: #{tile.inspect}") unless valid?

    @image = get_image
  end

  def valid?
    !@tile.nil? && !@tile.h.nil? && !@tile.v.nil? && !@viewport.nil?
  end

  def width
    WIDTH
  end

  def height
    HEIGHT
  end

  def z_index
    1
  end

  def x
    @tile.h * width
  end

  def x1
    x + width
  end

  def y
    @tile.v * height
  end

  def y1
    y + height
  end

  def mouse_on
    @mouse = true
    if @tile.battlefield && @tile.battlefield.respond_to?(:mouse_tile=)
      @tile.battlefield.mouse_tile = @tile
    end
  end

  def mouse_off
    @mouse = false
  end

  def draw_hook offset = nil
    offset_x, offset_y = offset || [0, 0]
    if mouse
      Gosu.draw_rect(x+offset_x, y+offset_y, width, height, Gosu::Color.new(50, 255, 255, 255), z_index+1)
    end
  end

  private

  def texture_path
    if @tile.type == :floor
      "terrain/grass.png"
    end
  end
end
