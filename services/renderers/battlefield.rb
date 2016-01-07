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
        Renderer::BattlefieldTile.new(tile)
      end
    end

    @actors = @battlefield.actors.map do |actor|
      Renderer::BattlefieldActor.new(actor)
    end

    @kb_handler = KeyboardHandler.new
      .on(:down, Gosu::KbA) do
        @offset_x += 5
      end
      .on(:down, Gosu::KbD) do
        @offset_x -= 5
      end
      .on(:down, Gosu::KbW) do
        @offset_y += 5
      end
      .on(:down, Gosu::KbS) do
        @offset_y -= 5
      end
    Keyboard.set_handler(:battlefield_scroll, @kb_handler)
  end

  def update
    @actors = @actors.reject {|actor| !actor.valid?}
  end

  def draw
    offset = [@offset_x, @offset_y]
    @tiles.each do |tile_row|
      tile_row.each do |tile|
        if tile.in_viewport? @viewport, offset
          tile.draw offset
        end
      end
    end
    @actors.each do |actor|
      if actor.in_viewport? @viewport, offset
        actor.draw offset
      end
    end
  end

  def valid?
    !@viewport.nil? && !@battlefield.nil?
  end
end
