module Battlefield
  module Action
    class Move < Base
      def valid?
        super && (@actor.tile.h - @h).abs <= 1 && (@actor.tile.v - @v).abs <= 1
      end

      def perform!
        super
        
        @actor.tile = @battlefield.get_tile(@h, @v)
        Logger.info "#{@actor.to_s} moved to #{@h}, #{@v} for #{action_points_spent} and has #{@actor.action_points}/#{@actor.max_action_points} AP left"
      end
    end
  end
end
