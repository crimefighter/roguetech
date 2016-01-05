module Battlefield
end

class Battlefield::Battlefield
  attr_reader :tiles, :actors, :width, :height, :current_turn

  def initialize options
    @width = options.fetch(:width, 0)
    @height = options.fetch(:height, 0)
    @player = options[:player]

    @actors = []

    raise ArgumentError.new("Invalid arguments for Battlefield::Battlefield: #{options.inspect}") unless valid?

    generate_tiles!

    @current_turn = Battlefield::Turn.new(battlefield: self)
  end

  def add_actor actor
    @actors << actor
    actor.battlefield = self
  end

  def get_tile h, v
    @tiles[h][v] rescue nil
  end

  def valid_coordinates? h, v
    h >= 0 && v >= 0 && h < width && v < height
  end

  private

  def valid?
    @width > 0 && @height > 0
  end

  def generate_tiles!
    @tiles = (0..width).map do |h_pos|
      (0..height).map do |v_pos|
        Battlefield::Tile.new(terrain: :grass, v: v_pos, h: h_pos)
      end
    end
    puts @tiles.inspect
  end
end
