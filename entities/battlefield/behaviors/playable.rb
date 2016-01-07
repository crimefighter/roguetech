module Battlefield
  module Behavior
    module Playable
      def get_target_coordinates direction
        case direction
        when :up then [@tile.h, @tile.v-1]
        when :down then [@tile.h, @tile.v+1]
        when :left then [@tile.h-1, @tile.v]
        when :right then [@tile.h+1, @tile.v]
        end
      end

      def step direction
        target_h, target_v = get_target_coordinates(direction)
        if can_perform?(::Battlefield::Action::Move) && @battlefield.valid_coordinates?(target_h, target_v)
          ::Battlefield::Action::Move.new({
            h: target_h,
            v: target_v,
            battlefield: @battlefield,
            actor: self
          })
        end
      end

      def on_start_turn
        kb_handler = KeyboardHandler.new
        kb_handler.on(:up, Gosu::KbUp) { @actions << step(:up) }
        kb_handler.on(:up, Gosu::KbDown) { @actions << step(:down) }
        kb_handler.on(:up, Gosu::KbLeft) { @actions << step(:left) }
        kb_handler.on(:up, Gosu::KbRight) { @actions << step(:right) }

        Keyboard.set_handler :playable_actor, kb_handler
      end

      def on_end_turn
        Keyboard.remove_handler :playable_actor
      end
    end
  end
end
