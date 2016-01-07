module Battlefield
  module Behavior
    module Killable
      def die! cause
        ::Battlefield::Action::Die.new({
          cause: cause,
          actor: self,
          battlefield: @battlefield
        }).perform!
      rescue => e
        Logger.info "#{self}.to_s could not die! #{e.inspect}"
      end

      def should_die?
        hit_points.to_i <= 0
      end
    end
  end
end
