module Battlefield
  module Behavior
    module Damageable
      def self.extended(base)
        base.behavior_action_types[:playable] = [
          ::Battlefield::Action::TakeDamage
        ]
      end

      def take_damage! cause
        ::Battlefield::Action::TakeDamage.new({
          cause: cause,
          actor: self,
          battlefield: @battlefield
        }).perform!
      rescue => e
        Logger.error "#{self}.to_s could not take damage! #{e.inspect}"
      end
    end
  end
end
