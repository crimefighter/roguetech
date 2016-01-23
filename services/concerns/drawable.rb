module Drawable
  def self.included base
    base.send :attr_accessor, :offset
    class << base
      attr_reader :width, :height, :z_index
    end
  end

  def in_viewport? viewport, offset = nil
    offset_x, offset_y = offset || [0, 0]
    x+offset_x < viewport.x1 && y+offset_y < viewport.y1 && x+offset_x+width > viewport.x0 && y+offset_y+height > viewport.y0
  end

  def scale_x
    width.to_f / get_image.width.to_f
  end

  def scale_y
    height.to_f / get_image.height.to_f
  end

  def draw offset = nil, options = nil
    offset_x, offset_y = offset || [0, 0]
    if !get_image.nil?
      get_image.draw x+offset_x, y+offset_y, (z_index || 1), scale_x, scale_y
    end
    if respond_to?(:draw_hook)
      draw_hook offset, options
    end
  end

  def get_image
    @image ||= MediaLoader.get_texture(texture_path)
  end
end
