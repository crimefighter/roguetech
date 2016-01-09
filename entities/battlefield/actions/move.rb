module Battlefield
  module Action
    class Move < Base
      def valid?
        base = super && (@actor.tile.h - @h).abs <= 1 && (@actor.tile.v - @v).abs <= 1
        base && !get_tile.blocked? && get_tile.actor.nil?
      end

      def perform!
        super

        @actor.set_tile get_tile
        Logger.info "#{@actor.to_s} moved to #{@h}, #{@v} for #{action_points_spent} and has #{@actor.action_points}/#{@actor.max_action_points} AP left"
      end

      def get_tile
        @tile ||= @battlefield.get_tile @h, @v
      end
    end
  end
end
