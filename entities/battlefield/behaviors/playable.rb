module Battlefield
  module Behavior
    module Playable
      def self.extended(base)
        base.available_action_types = base.available_action_types | [
          ::Battlefield::Action::Move,
          ::Battlefield::Action::Attack
        ]
        puts base.inspect
      end

      def on_start_turn
        kb_handler = KeyboardHandler.new
        kb_handler.on(:up, Gosu::KbUp) { @actions << step(:up) }
        kb_handler.on(:up, Gosu::KbDown) { @actions << step(:down) }
        kb_handler.on(:up, Gosu::KbLeft) { @actions << step(:left) }
        kb_handler.on(:up, Gosu::KbRight) { @actions << step(:right) }
        kb_handler.on(:up, Gosu::Kb1) { @actions << step(:down_left) }
        kb_handler.on(:up, Gosu::Kb3) { @actions << step(:down_right) }
        kb_handler.on(:up, Gosu::Kb7) { @actions << step(:up_left) }
        kb_handler.on(:up, Gosu::Kb9) { @actions << step(:up_right) }

        Keyboard.set_handler :playable_actor, kb_handler
      end

      def on_end_turn
        Keyboard.remove_handler :playable_actor
      end

      def get_target_coordinates direction
        case direction
        when :up then [@tile.h, @tile.v-1]
        when :down then [@tile.h, @tile.v+1]
        when :left then [@tile.h-1, @tile.v]
        when :right then [@tile.h+1, @tile.v]
        when :up_left then [@tile.h-1, @tile.v-1]
        when :up_right then [@tile.h+1, @tile.v-1]
        when :down_left then [@tile.h-1, @tile.v+1]
        when :down_right then [@tile.h+1, @tile.v+1]
        end
      end

      def step direction
        target_h, target_v = get_target_coordinates(direction)
        target_tile = @battlefield.get_tile(target_h, target_v)
        if target_tile.actor.nil?
          move target_h, target_v
        else
          attack target_h, target_v
        end
      rescue => e
        Logger.info "Action was invalid and could not be performed: #{e.inspect}"
      end

      def move h, v
        if can_perform?(::Battlefield::Action::Move)
          ::Battlefield::Action::Move.new({
            h: h,
            v: v,
            battlefield: @battlefield,
            actor: self
          })
        end
      end

      def attack h, v
        if can_perform?(::Battlefield::Action::Attack)
          ::Battlefield::Action::Attack.new({
            h: h,
            v: v,
            battlefield: @battlefield,
            actor: self
          })
        end
      end

    end
  end
end
