module Renderer
end

class Renderer::Battlefield
  attr_accessor :offset_x, :offset_y

  def initialize(options)
    @battlefield = options[:battlefield]
    @viewport = options[:viewport]
    @offset_x, @offset_y = options[:offset] || [0, 0]

    raise ArgumentError.new("Invalid arguments for Renderer::Battlefield: #{options.inspect}") unless valid?

    @tiles = @battlefield.tiles.map do |tile_row|
      tile_row.map do |tile|
        Renderer::BattlefieldTile.new(tile, viewport: @viewport)
      end
    end

    @actors = @battlefield.actors.map do |actor|
      Renderer::BattlefieldActor.new(actor)
    end
  end

  def update
    @actors.reject! do |actor|
      !actor.valid?
    end
    @actors.each do |actor|
      actor.visible = actor.visible_on_battlefield?
    end

    if Gosu::button_down?(Gosu::KbA) then @offset_x += 5; end
    if Gosu::button_down?(Gosu::KbD) then @offset_x -= 5; end
    if Gosu::button_down?(Gosu::KbW) then @offset_y += 5; end
    if Gosu::button_down?(Gosu::KbS) then @offset_y -= 5; end
  end

  def draw
    offset = [@offset_x, @offset_y]
    each_tile do |tile|
      if tile_has_mouse?(tile)
        tile.mouse_on if !tile.mouse
      else
        tile.mouse_off if tile.mouse
      end
      if tile.in_viewport? @viewport, offset
        tile.draw offset
      end
    end
    @actors.each do |actor|
      if actor.visible && actor.in_viewport?(@viewport, offset)
        actor.draw offset
      else
        Gosu.draw_rect(actor.x+@offset_x, actor.y+@offset_y, actor.width, actor.height, Gosu::Color.new(50, 0, 0, 0), actor.z_index+1)
      end
    end
  end

  def valid?
    !@viewport.nil? && !@battlefield.nil?
  end

  def each_tile &block
    @tiles.each do |tile_row|
      tile_row.each do |tile|
        yield tile
      end
    end
  end

  def tile_has_mouse? tile
    @viewport.mouse_x >= tile.x + offset_x &&
    @viewport.mouse_x < tile.x1 + offset_x &&
    @viewport.mouse_y >= tile.y + offset_y &&
    @viewport.mouse_y < tile.y1 + offset_y
  end
end
