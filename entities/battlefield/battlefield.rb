module Battlefield
end

class Battlefield::Battlefield
  attr_reader :tiles, :actors, :width, :height, :current_turn, :grid_map, :pather
  attr_accessor :mouse_tile, :actions, :primary_actor

  include AASM

  aasm do
    state :peace, initial: true
    state :combat

    event :start_combat do
      transitions from: :peace, to: :combat, after: :on_start_combat
    end

    event :end_combat do
      transitions from: :combat, to: :peace, after: :on_end_combat
    end
  end

  def initialize options
    @width = options.fetch(:width, 0)
    @height = options.fetch(:height, 0)

    @actors = []
    @actions = []
    @tiles = []
    @mouse_tile = nil

    raise ArgumentError.new("Invalid arguments for Battlefield::Battlefield: #{options.inspect}") unless valid?

    generate_tiles!

    @grid_map = BattlefieldGridMap.new @width, @height, battlefield: self
    @pather = Polaris.new @grid_map
  end

  def inspect
    'Battlefield'
  end

  def start
    new_turn
  end

  def new_turn
    @current_turn = Battlefield::Turn.new(battlefield: self)
    @current_turn.start
  end

  def tick
    return if @current_turn.nil?
    new_turn if @current_turn.ended?
    @current_turn.tick if @current_turn.started?
  end

  def add_actor actor
    return unless actor.may_deploy?
    actor.deploy
    @actors << actor
    actor.battlefield = self
  end

  def remove_actor actor
    actor.remove_tile
    @actors.delete actor
  end

  def on_start_combat
  end

  def on_end_combat
  end

  def current_actor
    current_turn.current_actor
  end

  def get_tile h, v
    if valid_coordinates? h, v
      @tiles[h][v] rescue nil
    end
  end

  def valid_coordinates? h, v
    h >= 0 && v >= 0 && h < width && v < height
  end

  private

  def valid?
    @width > 0 && @height > 0
  end

  def generate_tiles!
    dungeon = Dungeon.new(@width, @height)
    @tiles = dungeon.cells.map do |cell_row|
      cell_row.map do |cell|
        if valid_coordinates? cell.x, cell.y
          Battlefield::Tile.new({
            battlefield: self,
            type: Battlefield::Tile.translate_type(cell.type),
            h: cell.x,
            v: cell.y
          })
        end
      end.compact
    end.compact
  end
end
