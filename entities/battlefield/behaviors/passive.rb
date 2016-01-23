module Battlefield
  module Behavior
    module Passive
      def self.attach(base)
        base.class.send :attr_accessor, :passive
        base.passive = true
      end

      def self.detach base
        base.passive = false
      end

      def passive?
        @passive
      end
    end
  end
end
