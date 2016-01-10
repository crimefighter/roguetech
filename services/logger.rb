class Logger
  class << self
    def info msg
      puts msg
    end

    def error msg
      puts "\e[31m#{msg}\e[0m"
    end
  end
end
