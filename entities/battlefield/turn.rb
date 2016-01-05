module Battlefield
end

class Battlefield::Turn
  def initialize options
    @battlefield = options[:battlefield]
    raise ArgumentError.new("Invalid arguments for Battlefield::Turn: #{options.inspect}") unless valid?

    @actor_queue = @battlefield.actors
    @actions = {}
  end

  def valid?
    !@battlefield.nil?
  end

  def start
    @actor_queue.each do |actor|
    end
  end

  private

  def create_action options
    action = Battlefield::Action.new options
    if remaining_action_points(action.actor) < action.action_point_cost
      raise 'Not enough AP'
    end
    action.perform!
    actions_of(action.actor) << action
  rescue => e
    puts e.inspect
  end

  def actions_of actor
    @actions[actor.object_id] ||= []
  end

  def remaining_action_points actor
    actions_of(actor).map do |action|
      action.action_point_cost.to_i
    end.sum
  end
end
