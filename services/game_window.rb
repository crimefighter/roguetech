class GameWindow < Gosu::Window
  def initialize
    super 800, 600
    self.caption = "Roguetech"
    @battlefield = Battlefield::Battlefield.new(width: 20, height: 20)
    @battlefield.add_actor(Battlefield::Actor.new(tile: @battlefield.tiles.first.first))
    @viewport = Viewport.new(0, 0, 800, 600)
    @battlefield_renderer = Renderer::Battlefield.new({
      battlefield: @battlefield,
      viewport: @viewport
    })
  end

  def button_up btn_code
    Keyboard.handle_up btn_code
  end

  def update
    Keyboard.handle_down
  end

  def draw
    @battlefield_renderer.draw
  end
end
