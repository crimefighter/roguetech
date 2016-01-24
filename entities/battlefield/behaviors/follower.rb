module Battlefield
  module Behavior
    module Follower
      def set_follow_target actor
        @follow_target = actor
      end

      def follow_target
        @follow_target
      end

      def follower?
        true
      end

      def decide_behavior
        if (!@path_stack || @path_stack.empty?) && may_wait?
          wait
        end
      end

      def start_turn
        return if follow_target.nil?
        follow follow_target
      end

      def end_turn
        clear_path_stack!
      end

      def follow actor
        return if actor.nil? || actor.tile.nil?
        if respond_to? :path_to
          @path_stack = path_to actor.tile
          @path_stack.pop if @path_stack
          # remove last step to player occupied tile that's not marked as blocking movement
          # otherwise path would not be built and i'll have to determine target neighbour tile by myself
        end
      end
    end
  end
end
