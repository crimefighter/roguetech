module Battlefield
  module Behavior
    module Movable
      def attach
        behavior_action_types[:movable] = [
          ::Battlefield::Action::Move
        ]
      end

      def detach
        behavior_action_types[:movable] = nil
      end

      def decide_behavior
        if !(@actions && !@actions.empty?) && (@path_stack && !@path_stack.empty?)
          waypoint = @path_stack.shift.location
          (@actions ||= []) << move(waypoint.x, waypoint.y)
        end
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
        new_action = try_displace(h, v)
        return new_action if new_action

        Logger.info "Can't walk there!"
        clear_path_stack!
      end

      def path_to target_tile
        return if @tile.x == target_tile.x && @tile.y == target_tile.y
        return if !@battlefield.pather

        from = BattlefieldGridLocation.new(@tile.x, @tile.y)
        to = BattlefieldGridLocation.new(target_tile.x, target_tile.y)

        @battlefield.pather.guide(from, to)
      end

      def try_displace h, v
        target_tile = @battlefield.get_tile(h, v)
        return if target_tile.nil?
        target_actor = target_tile.actor
        if target_actor && target_actor.respond_to?(:displaceable?) && target_actor.displaceable?
          target_actor.give_way(self)
        end
      rescue => e
        puts "Displace failed"
      end
    end
  end
end
