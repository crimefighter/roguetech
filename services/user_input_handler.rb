require 'securerandom'

class UserInputHandler
  attr_accessor :queue

  def initialize
    @bindings = {up: [], down: []}
  end

  def on event, btn_code, identifier = nil, &block
    @bindings[event] ||= {}
    (@bindings[event][btn_code] ||= []) << {identifier: identifier, block: block}
    self
  end
  def off event, btn_code, identifier = nil
    return if @bindings[event].nil?
    if identifier.nil?
      @bindings[event][btn_code] = []
    else
      (@bindings[event][btn_code] ||= []).delete_if {|binding| binding.identifier == identifier}
    end
    self
  end

  def handle event, btn_code
    (@bindings[event][btn_code] || []).each do |binding|
      binding[:block].call
    end
  end
end
