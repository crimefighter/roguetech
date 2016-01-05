class Viewport
  attr_accessor :x0, :y0, :x1, :y1

  def initialize *args
    @x0, @y0, @x1, @y1 = args
  end
end
