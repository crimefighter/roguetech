module Battlefield
  module Behavior
    module Damageable
      def take_damage amount
        @hit_points = [hit_points.to_i - amount.to_i, 0].max
      end
    end
  end
end
