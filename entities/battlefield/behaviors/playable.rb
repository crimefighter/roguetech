module Battlefield
  module Behavior
    module Playable
      def playable?
        true
      end

      def initiative
        100
      end

      def start_turn
        if enemies_present?
          clear_path_stack!
        end
        wait_for_input
      end

      def end_turn
        UserInput.remove_handler :playable_actor
      end

      def wait_for_input
        input_handler = UserInputHandler.new
          .on(:up, Gosu::KbUp) { @actions << step(:up) }
          .on(:up, Gosu::KbDown) { @actions << step(:down) }
          .on(:up, Gosu::KbLeft) { @actions << step(:left) }
          .on(:up, Gosu::KbRight) { @actions << step(:right) }
          .on(:up, Gosu::Kb1) { @actions << step(:down_left) }
          .on(:up, Gosu::Kb3) { @actions << step(:down_right) }
          .on(:up, Gosu::Kb7) { @actions << step(:up_left) }
          .on(:up, Gosu::Kb9) { @actions << step(:up_right) }
          .on(:up, Gosu::MsLeft) do
            if @battlefield.respond_to?(:mouse_tile) && mouse_tile = @battlefield.mouse_tile
              if (target_actor = mouse_tile.actor) && respond_to?(:can_attack?) && can_attack?(target_actor)
                @actions << attack(mouse_tile.h, mouse_tile.v)
              else
                @path_stack = path_to(mouse_tile)
              end
            end
          end

        UserInput.set_handler :playable_actor, input_handler
      end

      def step direction
        target_h, target_v = get_target_coordinates(direction)
        target_tile = @battlefield.get_tile(target_h, target_v)
        if target_tile.actor.nil? && respond_to?(:move)
          move target_h, target_v
        elsif respond_to?(:attack)
          attack target_h, target_v
        end
      rescue => e
        Logger.info "Action was invalid and could not be performed: #{e.inspect}"
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

      def enemies_present?
        sighted_actors_in_party.any? do |actor|
          actor.visible_actors.any? do |visible_actor|
            visible_actor.has_behavior?(::Battlefield::Behavior::Enemy)
          end
        end
      end

      def sighted_actors_in_party
        @battlefield.actors.reject do |actor|
          !(
            (actor.has_behavior?(::Battlefield::Behavior::Playable) ||
            actor.has_behavior?(::Battlefield::Behavior::Companion)) &&
            actor.has_behavior?(::Battlefield::Behavior::Sighted)
          )
        end
      end
    end
  end
end
