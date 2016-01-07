module Battlefield
  module Action
    class Attack < Base
      def valid?
        base = super && (@actor.tile.h - @h).abs <= 1 && (@actor.tile.v - @v).abs <= 1
        base && !target_actor.nil?
      end

      def perform!
        super
        damage = 50

        if target_actor.respond_to? :take_damage
          target_actor.take_damage damage

          Logger.info "#{@actor.to_s} attacks #{target_actor.to_s} for #{damage} damage spending #{action_points_spent} AP and has #{@actor.action_points}/#{@actor.max_action_points} AP left"

          if target_actor.respond_to?(:should_die?)
            target_actor.die!(self) if target_actor.should_die?
          end
        end
      end

      def get_tile
        @tile ||= @battlefield.get_tile @h, @v
      end

      def target_actor
        get_tile.actor unless get_tile.nil?
      end
    end
  end
end
