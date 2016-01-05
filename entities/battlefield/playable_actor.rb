module Battlefield
  module PlayableActor
    def step direction
      target_h, target_v = case direction
      when :up then [@tile.h, @tile.v-1]
      when :down then [@tile.h, @tile.v+1]
      when :left then [@tile.h-1, @tile.v]
      when :right then [@tile.h+1, @tile.v]
      end

      if can_move_to? target_h, target_v
        move_to target_h, target_v
      end
    end
  end
end
