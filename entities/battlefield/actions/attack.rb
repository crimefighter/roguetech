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

        Logger.info "#{@actor.to_s} attacks #{target_actor.to_s} spending #{action_points_spent} AP and has #{@actor.action_points}/#{@actor.max_action_points} AP left"

        if target_actor.respond_to? :take_damage
          target_actor.take_damage damage

          Logger.info "#{target_actor.to_s} loses #{damage} HP and has #{target_actor.hit_points}/#{target_actor.max_hit_points} HP left"

          if target_actor.respond_to?(:should_die?)
            target_actor.die!(self) if target_actor.should_die?
          else
            Logger.info "#{target_actor.to_s} cannot die"
          end
        else
          Logger.info "#{target_actor.to_s} cannot be damaged"
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
