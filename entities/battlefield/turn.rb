module Battlefield
end

class Battlefield::Turn
  include AASM

  aasm do
    state :idle, initial: true
    state :started
    state :ended

    event :start do
      transitions from: :idle, to: :started, after: :on_start
    end

    event :finish do
      transitions from: :started, to: :ended, after: :on_end
    end
  end

  def initialize options
    @battlefield = options[:battlefield]
    @actor_queue = build_actor_queue @battlefield.actors

    raise ArgumentError.new("Invalid arguments for Battlefield::Turn: #{options.inspect}") unless valid?

    @current_actor_index = 0
    @performed_actions = {}
  end

  def valid?
    !@battlefield.nil? && !@actor_queue.nil? && !@actor_queue.empty?
  end

  def on_start
    Logger.info "Turn started: #{self.to_s}"
  end

  def on_end
    Logger.info "Turn ended: #{self.to_s}"
  end

  def tick
    if current_actor.nil?
      finish if may_finish?
      return
    end

    if current_actor.respond_to?(:passive?) && current_actor.passive?
      activate_next_actor!
      return
    end

    current_actor.start_turn if current_actor.may_start_turn?

    current_actor.behavior_event(:decide_behavior)

    if action = current_actor.shift_action
      action.perform!
      performed_actions_of(current_actor) << action
    end

    if (current_actor.available_actions.empty? || current_actor.waiting?) && current_actor.may_end_turn?
      current_actor.end_turn
      activate_next_actor!
    end
  end

  def current_actor
    @actor_queue[@current_actor_index]
  end

  def build_actor_queue actors
    actors.sort do |actor1, actor2|
      actor2.try(:initiative).to_i <=> actor1.try(:initiative).to_i
    end
  end

  private

  def activate_next_actor!
    Logger.info "#{current_actor.to_s} ends his turn" if current_actor
    @current_actor_index += 1
  end

  def performed_actions_of actor
    @performed_actions[actor.object_id] ||= []
  end
end
