module Battlefield
  module Behavior
    module Playable
      def self.extended(base)
        base.behavior_action_types[:playable] = [
          ::Battlefield::Action::Move,
          ::Battlefield::Action::Attack
        ]
      end

      def self.detach base
        base.available_action_types[:playable] = nil
      end

      def shift_action
        action = super
        if action.nil? && @path_stack && !@path_stack.empty?
          waypoint = @path_stack.shift.location
          action = move(waypoint.x, waypoint.y)
        end
        action
      end

      def on_start_turn
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
            if @battlefield.respond_to?(:mouse_tile) && @battlefield.mouse_tile
              @path_stack = path_to(@battlefield.mouse_tile)
            end
          end

        UserInput.set_handler :playable_actor, input_handler
      end

      def on_end_turn
        UserInput.remove_handler :playable_actor
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
      rescue => e
        Logger.info "Can't walk there!"
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
      rescue => e
      end

      def path_to target_tile
        return if @tile.x == target_tile.x && @tile.y == target_tile.y
        return if !@battlefield.pather

        from = BattlefieldGridLocation.new(@tile.x, @tile.y)
        to = BattlefieldGridLocation.new(target_tile.x, target_tile.y)

        @battlefield.pather.guide(from, to)
      end
    end
  end
end
