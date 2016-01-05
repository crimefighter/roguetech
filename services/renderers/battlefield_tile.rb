module Renderer
end

class Renderer::BattlefieldTile
  include Drawable

  WIDTH = 128
  HEIGHT = 128

  def initialize(tile)
    @tile = tile

    raise ArgumentError.new("Invalid arguments for Rendered::BattlefieldTile: #{tile.inspect}") unless valid?

    @image = get_image
  end

  def valid?
    !@tile.nil? && !@tile.h.nil? && !@tile.v.nil?
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

  def y
    @tile.v * height
  end

  private

  def texture_path
    "terrain/#{@tile.terrain}.png"
  end
end
