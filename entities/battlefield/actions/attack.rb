module Battlefield
  module Action
    class Attack < Base
      def self.action_point_cost_for actor
        50
      end

      def valid?
        super && !target_actor.nil? && @actor.respond_to?(:attack_range) && @actor.respond_to?(:attack_damage) && target_in_range?
      end

      def perform!
        super
        damage = 50

        Logger.info "#{@actor.to_s} attacks #{target_actor.to_s} spending #{action_points_spent} AP and has #{@actor.action_points}/#{@actor.max_action_points} AP left"

        if target_actor.respond_to? :take_damage!
          target_actor.take_damage! self
        else
          Logger.info "#{target_actor.to_s} cannot be damaged"
        end
      end

      def target_in_range?
        @actor.target_in_attack_range?(@h, @v)
      end

      def damage
        @actor.attack_damage
      end
    end
  end
end
