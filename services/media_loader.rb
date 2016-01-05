class MediaLoader
  class << self
    @@textures = {}

    def get_texture file_name
      @@textures[file_name] ||= Gosu::Image.new("media/textures/#{file_name}", :tileable => true)
    end
  end
end
