require 'securerandom'

class KeyboardHandler
  def initialize
    @bindings = {}
  end

  def on event, btn_code, identifier = nil, &block
    @bindings[event] ||= {}
    (@bindings[event][btn_code] ||= []) << {identifier: identifier, block: block}
  end

  def off event, btn_code, identifier = nil
    return if @bindings[event].nil?
    if identifier.nil?
      @bindings[event][btn_code] = []
    else
      (@bindings[event][btn_code] ||= []).delete_if {|binding| binding.identifier == identifier}
    end
  end

  def handle_down
    @bindings[:down].each do |btn_code, bindings|
      if Gosu::button_down? btn_code
        bindings.each do |binding|
          binding[:block].call
        end
      end
    end
  end

  def handle_up btn_code
    (@bindings[:up][btn_code] || []).each do |binding|
      binding[:block].call
    end
  end
end
