class Keyboard
  class << self
    @@handlers = {}

    def set_handler handler_id, handler
      @@handlers[handler_id] = handler
    end

    def remove_handler handler_id
      @@handlers[handler_id] = nil
    end

    def clear_handlers
      @@handlers = {}
    end

    def handle_down
      @@handlers.each(&:handle_down)
    end

    def handle_up btn_code
      @@handlers.each do |handler|
        handler.handle_up btn_code
      end
    end
  end
end
