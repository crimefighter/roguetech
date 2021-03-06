module Battlefield
  module Action
    class Base
      def self.action_point_cost_for actor
        50
      end

      attr_reader :action_points_spent, :h, :v

      def initialize options
        @h = options[:h]
        @v = options[:v]
        @battlefield = options[:battlefield]
        @actor = options[:actor]
        @action_points_spent = 0
        raise ArgumentError.new("Invalid arguments for Battlefield::Action: #{options.inspect}") unless valid?
      end

      def available_action_types
        @@available_action_types
      end

      def valid?
        base = !@h.nil? && !@v.nil? && !@battlefield.nil? && !@actor.nil?
        base && @battlefield.valid_coordinates?(@h, @v)
      end

      def action_point_cost
        self.class.action_point_cost_for(@actor)
      end

      def perform!
        @action_points_spent = action_point_cost
        @actor.spend_action_points(@action_points_spent)
      end

      def get_tile
        @tile ||= @battlefield.get_tile @h, @v
      end

      def target_actor
        return if get_tile.nil?
        @target_actor ||= get_tile.actor
      end
    end
  end
end
