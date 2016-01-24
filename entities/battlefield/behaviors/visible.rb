module Battlefield
  module Behavior
    module Visible

        def visible_to? actor
          @visibilities ||= {}
          @visibilities[[actor.object_id, actor.tile.x, actor.tile.y].join('-')] ||= actor.respond_to?(:can_see?) && actor.can_see?(self)
        end

        def visible_to_playable_actors?
          return true if respond_to?(:playable?) && playable?
          @battlefield.actors.any? do |actor|
            actor.respond_to?(:playable?) && actor.playable? && visible_to?(actor)
          end
        end

        def reset_visibility_cache!
          @visibilities = {}
        end
    end
  end
end
