class MediaLoader
  class << self
    @@textures = {}

    def get_texture file_name
      return unless file_name
      @@textures[file_name] ||= Gosu::Image.new("media/textures/#{file_name}", :tileable => true)
    end

    def get_tiles file_name, tile_width, tile_height
      return unless file_name
      @@textures[file_name] ||= Gosu::Image.load_tiles("media/textures/#{file_name}", tile_width, tile_height, :tileable => true)
    end
  end
end
