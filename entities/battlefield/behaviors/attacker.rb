module Battlefield
  module Behavior
    module Attacker
      def attach
        behavior_action_types[:attacker] = [
          ::Battlefield::Action::Attack
        ]
      end

      def detach
        behavior_action_types[:attacker] = nil
      end

      def attack h, v
        if can_perform?(::Battlefield::Action::Attack)
          ::Battlefield::Action::Attack.new({
            h: h,
            v: v,
            battlefield: @battlefield,
            actor: self
          })
        end
      rescue => e
        Logger.error "Can't attack! #{e}"
      end

      def attack_range
        5
      end

      def target_in_attack_range? h, v
        (tile.h - h).abs <= attack_range && (tile.v - v).abs <= attack_range
      end

      def can_attack? actor
        base = !(actor.respond_to?(:playable?) && actor.playable?)
        base && respond_to?(:target_in_attack_range?) && target_in_attack_range?(actor.tile.h, actor.tile.v)
      end

      def attack_damage
        50
      end
    end
  end
end
