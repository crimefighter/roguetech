module Battlefield
  module Behavior
    module Displaceable

        def displaceable?
          true
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
        end
    end
  end
end
