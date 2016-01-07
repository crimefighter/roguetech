class GameWindow < Gosu::Window
  def initialize
    super 800, 600
    self.caption = "Roguetech"
    @battlefield = Battlefield::Battlefield.new(width: 20, height: 20)
    @battlefield.add_actor Battlefield::Actor.new({
      tile: @battlefield.tiles.first.first,
      behavior: Battlefield::Behavior::Playable
    })
    @battlefield.add_actor Battlefield::Actor.new({
      tile: @battlefield.tiles[3][3],
      behavior: Battlefield::Behavior::Playable
    })
    @viewport = Viewport.new(0, 0, 800, 600)
    @battlefield_renderer = Renderer::Battlefield.new({
      battlefield: @battlefield,
      viewport: @viewport
    })
    @battlefield.start
  end

  def button_up btn_code
    Keyboard.handle :up, btn_code
  end

  def button_down btn_code
    Keyboard.handle :down, btn_code
  end

  def update
    @battlefield.tick
  end

  def draw
    @battlefield_renderer.draw
  end
end
