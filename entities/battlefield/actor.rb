module Battlefield
end

class Battlefield::Actor
  attr_reader :actions, :action_points
  attr_accessor :battlefield, :tile

  include AASM

  aasm do
    state :idle, initial: true
    state :active

    event :start_turn do
      transitions from: :idle, to: :active do
        after do
          reset_action_points!
          on_start_turn if respond_to?(:on_start_turn)
        end
      end
    end

    event :end_turn do
      transitions from: :active, to: :idle do
        after do
          on_end_turn if respond_to?(:on_start_turn)
        end
      end
    end
  end

  include Battlefield::Behavior::Playable

  def initialize options
    @tile = options[:tile]
    @battlefield = options[:battlefield]

    @actions = []

    raise ArgumentError.new("Invalid arguments for Battlefield::Actor: #{options.inspect}") unless valid?
  end

  def available_action_types
    [
      Battlefield::Action::Move
    ]
  end

  def can_perform? action
    action_type = if action.is_a?(Battlefield::Action::Base)
      action.class
    else
      action
    end
    available_action_types.include? action_type
  end

  def has_action_points_for? action
    action.action_point_cost_for(self) <= action_points.to_i
  end

  def available_actions
    available_action_types.reject do |type|
      !has_action_points_for?(type)
    end
  end

  def valid?
    !@tile.nil?
  end

  def max_action_points
    100
  end

  def spend_action_points amount
    if amount <= @action_points
      @action_points -= amount
    end
    @action_points
  end

  def reset_action_points!
    @action_points = max_action_points
  end

  def shift_action
    @actions.shift
  end
end
