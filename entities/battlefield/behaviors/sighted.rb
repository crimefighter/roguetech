module Battlefield
  module Behavior
    module Sighted

        def sight_radius
          10
        end

        def can_see? actor
          return false if actor.idle? || actor.tile.nil?
          in_sight_radius?(actor) && line_of_sight?(actor)
        end

        def in_sight_radius? actor
          (tile.x - actor.tile.x).abs <= sight_radius && (tile.y - actor.tile.y).abs <= sight_radius
        end

        def line_of_sight? actor
          Bresenham::Line.coordinates(tile.x, tile.y, actor.tile.x, actor.tile.y).to_a.all? do |coords|
            tile = @battlefield.get_tile(*coords)
            tile && !tile.blocks_vision?
          end
        rescue => e
          Logger.error "Could not calculate line of sight from #{self} to #{actor}!: #{e.inspect}"
          return false
        end

        def actors_in_sight_radius
          @battlefield.actors.reject do |actor|
            actor == self || !in_sight_radius?(actor)
          end
        end

        def visible_actors
          actors_in_sight_radius.reject do |actor|
            !can_see?(actor)
          end
        end
    end
  end
end
