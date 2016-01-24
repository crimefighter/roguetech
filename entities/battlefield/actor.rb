module Battlefield
end

class Battlefield::Actor
  attr_reader :tile, :path_stack, :actions, :behaviors, :action_points, :hit_points
  attr_accessor :battlefield, :behavior_action_types

  include AASM

  aasm do
    state :idle, initial: true
    state :ready
    state :active
    state :waiting
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
          behavior_event(:start_turn)
        end
      end
    end

    event :wait do
      transitions from: :active, to: :waiting
    end

    event :end_turn do
      transitions from: [:active, :waiting], to: :ready do
        after do
          behavior_event(:end_turn)
        end
      end
    end

    event :become_dead do
      transitions from: [:ready, :active, :waiting], to: :dead do
        after do
          behavior_event(:become_dead)
        end
      end
    end
  end

  def initialize options
    @battlefield = options[:battlefield]
    set_tile options[:tile]

    @actions = []
    @path_stack = []
    @behaviors = []
    @behavior_action_types = {}

    raise ArgumentError.new("Invalid arguments for Battlefield::Actor: #{options.inspect}") unless valid?

    (options[:behaviors] || []).each do |behavior|
      add_behavior behavior
    end
  end

  def method_missing symbol, *args
    behavior = behavior_responding_to symbol
    if !behavior.nil?
      meth = behavior.instance_method(symbol).bind(self)
      meth.call(*args)
    else
      super
    end
  end

  def respond_to? symbol
    super || !behavior_responding_to(symbol).nil?
  end

  def behavior_responding_to symbol
    @behaviors.find do |behavior|
      behavior.instance_methods.include?(symbol)
    end
  end

  def add_behavior behavior
    return if !behavior || @behaviors.include?(behavior)
    @behaviors << behavior
    if behavior.instance_methods.include?(:attach)
      behavior.instance_method(:attach).bind(self).call
    end
    behavior.attach(self) if behavior.respond_to?(:attach)
  end

  def remove_behavior behavior
    @behaviors.delete behavior
    if behavior.instance_methods.include?(:detach)
      behavior.instance_method(:detach).bind(self).call
    end
  end

  def has_behavior? behavior
    @behaviors.include?(behavior)
  end

  def behavior_event symbol
    @behaviors.each do |behavior|
      if behavior.instance_methods.include?(symbol)
        behavior.instance_method(symbol).bind(self).call
      end
    end
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
    if amount <= (@action_points ||= 0)
      @action_points -= amount
    end
    @action_points
  end

  def reset_action_points!
    @action_points = max_action_points
  end

  def spend_hit_points amount
    @hit_points ||= 0
    @hit_points -= amount.to_i
  end

  def reset_hit_points!
    @hit_points = max_hit_points
  end

  def shift_action
    @actions.shift
  end

  def clear_path_stack!
    @path_stack = nil
  end

  def set_tile new_tile
    return unless new_tile
    raise "Tile is occupied" unless new_tile.actor.nil?

    remove_tile if @tile
    @tile = new_tile
    @tile.actor = self
  end

  def remove_tile
    tile.actor = nil
    @tile = nil
  end
end
