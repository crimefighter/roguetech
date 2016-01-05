module Renderer
end

class Renderer::BattlefieldActor
  include Drawable

  def initialize(actor)
    @actor = actor

    raise ArgumentError.new("Invalid arguments for Renderer::BattlefieldActor: #{actor.inspect}") unless valid?

    @image = get_image

    Keyboard.on(:up, Gosu::KbUp) { @actor.step :up }
    Keyboard.on(:up, Gosu::KbLeft) { @actor.step :left }
    Keyboard.on(:up, Gosu::KbDown) { @actor.step :down }
    Keyboard.on(:up, Gosu::KbRight) { @actor.step :right }
  end

  def tile
    @actor.tile
  end

  def valid?
    !tile.nil? && !tile.h.nil? && !tile.v.nil?
  end

  def width
    101
  end

  def height
    171
  end

  def z_index
    10
  end

  def x
    tile.h * Renderer::BattlefieldTile::WIDTH
  end

  def y
    tile.v * Renderer::BattlefieldTile::HEIGHT - 50
  end

  private

  def texture_path
    "actors/actor.png"
  end
end
