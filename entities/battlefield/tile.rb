class Battlefield::Tile
  attr_reader :type, :h, :v, :battlefield

  attr_accessor :actor, :mouse

  def self.translate_type cell_type
    if cell_type < 2
      :blocked
    else
      :floor
    end
  end

  def initialize options
    @battlefield = options[:battlefield]
    @type = options[:type]
    @h = options[:h]
    @v = options[:v]

    @actor = nil

    @mouse = false

    raise ArgumentError.new("Invalid arguments for Battlefield::Tile: #{options.inspect}") unless valid?
  end

  def x
    h
  end

  def y
    v
  end

  def blocked?
    @type == :blocked
  end

  def blocks_vision?
    blocked?
  end

  def blocks_movement?
    return false if !blocked? && @actor.nil?
    !(@actor.respond_to?(:playable?) && @actor.playable?) &&
    !(@actor.respond_to?(:displaceable?) && @actor.displaceable?)
  end

  def blocks_path?
    blocked?
  end

  private

  def valid?
    !@battlefield.nil? && !@type.nil? && @battlefield.valid_coordinates?(h, v)
  end
end
