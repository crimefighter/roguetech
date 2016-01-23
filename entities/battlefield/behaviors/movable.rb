module Battlefield
  module Behavior
    module Movable
      def self.attach(base)
        base.behavior_action_types[:movable] = [
          ::Battlefield::Action::Move
        ]
      end

      def self.detach base
        base.available_action_types[:movable] = nil
      end

      def shift_action
        action = super
        if action.nil? && @path_stack && !@path_stack.empty?
          waypoint = @path_stack.shift.location
          action = move(waypoint.x, waypoint.y)
        end
        action
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
        clear_path_stack!
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
