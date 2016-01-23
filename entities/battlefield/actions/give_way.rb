module Battlefield
  module Action
    class GiveWay < Base
      def self.action_point_cost_for actor
        0
      end

      def valid?
        super && !target_actor.nil? && @actor.respond_to?(:displaceable?) && @actor.displaceable?
      end

      def perform!
        super

        self_tile = @actor.tile
        target_actor_tile = target_actor.tile
        @actor.remove_tile
        target_actor.set_tile self_tile
        @actor.set_tile target_actor_tile

        Logger.info "#{@actor.to_s} was displaced by #{target_actor}"
      end
    end
  end
end
