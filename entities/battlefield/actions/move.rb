module Battlefield
  module Action
    class Move < Base
      def valid?
        base = super && (@actor.tile.h - @h).abs <= 1 && (@actor.tile.v - @v).abs <= 1
        base && !tile_blocked_for_movement?
      end

      def perform!
        super

        @actor.set_tile get_tile

        Logger.info "#{@actor.to_s} moved to #{@h}, #{@v} for #{action_points_spent} and has #{@actor.action_points}/#{@actor.max_action_points} AP left"
        @actor.reset_visibility_cache! if @actor.respond_to?(:reset_visibility_cache!)
      end

      def tile_blocked_for_movement?
        get_tile.blocks_movement?
      end
    end
  end
end
