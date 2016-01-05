module Battlefield
end

class Battlefield::Action
  def initialize options
    @h = options[:h]
    @v = options[:v]
    @type = options[:type]
    @battlefield = options[:battlefield]
    @actor = options[:actor]
    raise ArgumentError.new("Invalid arguments for Battlefield::Action: #{options.inspect}") unless valid?
  end

  def valid?
    base = !@h.nil? && !@v.nil? && !@type.nil? && !@battlefield.nil? && !@actor.nil?
    base && @battlefield.valid_coordinates?(@h, @v)
  end

  def action_point_cost
    100
  end
end
