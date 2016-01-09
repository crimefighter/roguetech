class Viewport
  attr_accessor :x0, :y0, :x1, :y1

  def initialize x0, y0, x1, y1, options = nil
    @x0, @y0, @x1, @y1 = x0, y0, x1, y1
    options ||= {}
    @window = options[:window]

    raise ArgumentError.new("Invalid arguments for Viewport: #{options.inspect}") unless valid?
  end

  def mouse_x
    @window.mouse_x
  end

  def mouse_y
    @window.mouse_y
  end

  def mouse?
    mouse_x >= @x0 && mouse_x < @x1 && mouse_y >= @y0 && mouse_y < @y1
  end

  def valid?
    !@window.nil?
  end
end
