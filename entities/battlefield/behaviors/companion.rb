module Battlefield
  module Behavior
    module Companion

        def set_master actor
          @master = actor
        end

        def master
          @master
        end

        def companion?
          true
        end

        def start_turn
          if enemies_present?
            if has_behavior?(::Battlefield::Behavior::Follower)
              remove_behavior(::Battlefield::Behavior::Follower)
              puts "remove follower"
            end
            if !has_behavior?(::Battlefield::Behavior::Playable)
              add_behavior(::Battlefield::Behavior::Playable)
              behavior_event(:start_turn)
              puts "add playable"
            end
          else
            if has_behavior?(::Battlefield::Behavior::Playable)
              remove_behavior(::Battlefield::Behavior::Playable)
              puts "remove playable"
            end
            if !has_behavior?(::Battlefield::Behavior::Follower)
              add_behavior(::Battlefield::Behavior::Follower)
              set_follow_target master
              behavior_event(:start_turn)
              puts "add follower #{follow_target}"
            end
          end
        end

        def enemies_present?
          sighted_actors_in_party.any? do |actor|
            actor.visible_actors.any? do |visible_actor|
              visible_actor.has_behavior?(::Battlefield::Behavior::Enemy)
            end
          end
        end

        def sighted_actors_in_party
          @battlefield.actors.reject do |actor|
            !(
              (actor.has_behavior?(::Battlefield::Behavior::Playable) ||
              actor.has_behavior?(::Battlefield::Behavior::Companion)) &&
              actor.has_behavior?(::Battlefield::Behavior::Sighted)
            )
          end
        end
    end
  end
end
