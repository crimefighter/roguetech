class Battlefield::Tile
  attr_reader :terrain, :h, :v

  def initialize options
    @terrain = options[:terrain]
    @h = options[:h]
    @v = options[:v]

    raise ArgumentError.new("Invalid arguments for Battlefield::Tile: #{options.inspect}") unless valid?
  end

  private

  def valid?
    !@terrain.nil?
  end
end
