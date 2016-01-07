module Battlefield
  module Action
    class Die < Base
      def initialize options
        @cause = options[:cause]
        super
      end

      def valid?
        !@battlefield.nil? && !@actor.nil? && !@cause.nil? && @actor.may_become_dead?
      end

      def perform!
        super

        @actor.become_dead
        Logger.info "#{@actor.to_s} has died due to #{@cause}"
        puts @battlefield.actors.inspect
        @battlefield.remove_actor @actor
        puts @battlefield.actors.inspect
      end

      def get_tile
        @tile ||= @battlefield.get_tile @h, @v
      end
    end
  end
end
