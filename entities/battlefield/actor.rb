module Battlefield
end

class Battlefield::Actor
  attr_reader :tile, :actions, :action_points, :hit_points
  attr_accessor :battlefield, :behavior_action_types

  include AASM

  aasm do
    state :idle, initial: true
    state :ready
    state :active
    state :dead

    event :deploy do
      transitions from: :idle, to: :ready do
        after do
          reset_hit_points!
          on_deploy if respond_to?(:on_deploy)
        end
      end
    end

    event :start_turn do
      transitions from: :ready, to: :active do
        after do
          reset_action_points!
          on_start_turn if respond_to?(:on_start_turn)
        end
      end
    end

    event :end_turn do
      transitions from: :active, to: :ready do
        after do
          on_end_turn if respond_to?(:on_start_turn)
        end
      end
    end

    event :become_dead do
      transitions from: [:ready, :active], to: :dead do
        after do
          on_become_dead if respond_to?(:on_become_dead)
        end
      end
    end
  end

  def initialize options
    @battlefield = options[:battlefield]
    set_tile options[:tile]

    @actions = []
    @behaviors = []
    @behavior_action_types = {}

    raise ArgumentError.new("Invalid arguments for Battlefield::Actor: #{options.inspect}") unless valid?

    (options[:behaviors] || []).each do |behavior|
      add_behavior behavior
    end
  end

  def add_behavior behavior
    return if !behavior || @behaviors.include?(behavior)
    @behaviors << behavior
    self.extend behavior
  end

  def remove_behavior behavior
    @behaviors.delete behavior
    behavior.detach(self) if behavior.respond_to?(:detach)
  end

  def available_action_types
    behavior_action_types.values.flatten.compact.uniq
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

  def max_hit_points
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

  def reset_hit_points!
    @hit_points = max_hit_points
  end

  def shift_action
    @actions.shift
  end

  def set_tile new_tile
    return unless new_tile
    raise "Tile is occupied" unless new_tile.actor.nil?

    remove_tile if @tile
    @tile = new_tile
    new_tile.actor = self
    # @battlefield.grid_map.place BattlefieldGridLocation.new(new_tile.h, new_tile.v), self.object_id
  end

  def remove_tile
    # @battlefield.grid_map.clear BattlefieldGridLocation.new(tile.h, tile.v)
    tile.actor = nil
    @tile = nil
  end
end
