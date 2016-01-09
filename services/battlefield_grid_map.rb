class BattlefieldGridMap < TwoDGridMap
  def initialize w, h, options = nil
    super w, h
    options ||= {}
    @battlefield = options[:battlefield]
  end

  def blocked? location, type = nil
    tile = @battlefield.get_tile location.x, location.y
    return true if tile.nil? || tile.blocked?
    !tile.actor.nil? && tile.actor != @battlefield.current_actor
  end
end
