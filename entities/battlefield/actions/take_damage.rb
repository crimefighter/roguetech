module Battlefield
  module Action
    class TakeDamage < Base
      def self.action_point_cost_for actor
        0
      end

      def initialize options
        @cause = options[:cause]
        super
      end

      def valid?
        !@battlefield.nil? && !@actor.nil? && !@cause.nil?
      end

      def perform!
        super
        amount = @cause.damage

        @actor.spend_hit_points amount

        Logger.info "#{@actor.to_s} takes #{amount} damage due to #{@cause}"

        if @actor.respond_to?(:should_die?) && @actor.should_die?
          @actor.die!(self)
        end
      end

      def get_tile
        @tile ||= @battlefield.get_tile @h, @v
      end
    end
  end
end
