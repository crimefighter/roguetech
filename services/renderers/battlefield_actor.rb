module Renderer
end

class Renderer::BattlefieldActor
  include Drawable

  attr_accessor :visible

  def initialize(actor)
    @actor = actor

    @visible = false

    raise ArgumentError.new("Invalid arguments for Renderer::BattlefieldActor: #{actor.inspect}") unless valid?

    @image = get_image
  end

  def tile
    @actor.tile
  end

  def valid?
    !@actor.nil? && !tile.nil? && !tile.h.nil? && !tile.v.nil?
  end

  def width
    50
  end

  def height
    85
  end

  def z_index
    10
  end

  def x
    tile.h * Renderer::BattlefieldTile::WIDTH
  end

  def y
    tile.v * Renderer::BattlefieldTile::HEIGHT - 25
  end

  def visible_on_battlefield?
    @actor.respond_to?(:visible_to_playable_actors?) && @actor.visible_to_playable_actors?
  end

  def draw_hook offset = nil, options = nil
    offset_x, offset_y = offset || [0, 0]
    options ||= {}
    if options[:current_actor] && options[:current_actor].object_id == @actor.object_id
      Gosu.draw_rect(x+offset_x, y+offset_y, width, height, Gosu::Color.new(50, 255, 0, 0), z_index+1)
    end
  end

  private

  def texture_path
    "actors/actor.png"
  end
end
