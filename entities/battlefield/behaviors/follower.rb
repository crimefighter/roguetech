module Battlefield
  module Behavior
    module Follower
      def self.attach(base)
        base.class.send :attr_accessor, :follower, :follow_target
        base.follower = true
      end

      def self.detach base
        base.follower = false
        base.follow_target = nil
      end

      def follower?
        @follower
      end

      def decide_behavior
        puts @path_stack.inspect
        puts may_end_turn?.inspect
        puts aasm.current_state.inspect
        if (!@path_stack || @path_stack.empty?) && may_wait?
          wait
        end
      end

      def on_start_turn
        return if follow_target.nil?
        follow follow_target
      end

      def on_end_turn
        clear_path_stack!
      end

      def follow actor
        return if actor.nil? || actor.tile.nil?
        if respond_to? :path_to
          @path_stack = path_to actor.tile
          @path_stack.pop
          # remove last step to player occupied tile that's not marked as blocking movement
          # otherwise path would not be built and i'll have to determine target neighbour tile by myself
        end
      end
    end
  end
end
