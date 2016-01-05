module Battlefield
end

class Battlefield::Actor
  attr_reader :tile, :action
  attr_accessor :battlefield

  include PlayableActor

  def initialize options
    @tile = options[:tile]
    @battlefield = options[:battlefield]

    raise ArgumentError.new("Invalid arguments for Battlefield::Actor: #{options.inspect}") unless valid?
  end

  def valid?
    !@tile.nil?
  end

  def action_points
    100
  end
end
