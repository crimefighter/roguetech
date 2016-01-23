module Battlefield
  module Behavior
    module Displaceable
      def self.attach(base)
        base.class.send :attr_accessor, :displaceable
        base.displaceable = true
      end

      def self.detach base
        base.displaceable = false
      end

      def displaceable?
        @displaceable
      end

      def give_way to_actor
        ::Battlefield::Action::GiveWay.new({
          h: to_actor.tile.h,
          v: to_actor.tile.v,
          battlefield: @battlefield,
          actor: self
        }).perform!
      rescue => e
        Logger.info "Can't be displaced!"
        clear_path_stack!
      end
    end
  end
end
