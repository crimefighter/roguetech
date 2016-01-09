class GameWindow < Gosu::Window
  def initialize
    super 1600, 900
    self.caption = "Roguetech"
    @battlefield = Battlefield::Battlefield.new(width: 30, height: 30)
    @battlefield.add_actor Battlefield::Actor.new({
      battlefield: @battlefield,
      tile: @battlefield.tiles.flatten.find {|tile| !tile.blocked? && tile.actor.nil?},
      behaviors: [Battlefield::Behavior::Playable]
    })
    2.times do
      @battlefield.add_actor Battlefield::Actor.new({
        battlefield: @battlefield,
        tile: @battlefield.tiles.flatten.shuffle.find {|tile| !tile.blocked? && tile.actor.nil?},
        behaviors: [
          Battlefield::Behavior::Idle,
          Battlefield::Behavior::Damageable,
          Battlefield::Behavior::Killable
        ]
      })
    end
    @viewport = Viewport.new(0, 0, width, height, window: self)
    @battlefield_renderer = Renderer::Battlefield.new({
      battlefield: @battlefield,
      viewport: @viewport
    })
    @battlefield.start
  end

  def needs_cursor?
    true
  end

  def button_up btn_code
    UserInput.handle :up, btn_code
  end

  def button_down btn_code
    UserInput.handle :down, btn_code
  end

  def update
    @battlefield.tick
    @battlefield_renderer.update
  end

  def draw
    @battlefield_renderer.draw
  end
end
