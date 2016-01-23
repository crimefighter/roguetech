module Battlefield
  module Behavior
    module Companion
      def self.attach base
        base.class.send(:attr_accessor, :master)
        base.class.send(:attr_accessor, :companion)
        base.companion = true
      end

      def self.detach base
        base.master = nil
        base.companion = false
      end

      def companion?
        @companion
      end

      def decide_behavior
        if battlefield.peace?
          if respond_to?(:playable?) && playable? && !master.nil?
            remove_behavior(::Battlefield::Behavior::Playable)
            puts "remove playable"
          end
          if !(respond_to?(:follower?) && follower?) && !master.nil?
            add_behavior(::Battlefield::Behavior::Follower)
            follow_target = master
            puts "add follower #{follow_target}"
            puts available_action_types.inspect
          end
        end
      end
    end
  end
end
