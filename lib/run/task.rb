require "run/log"

module Run
  module Task
    extend self, Run::Log

    def run
      init
      setup if defined? setup
      main
      exit 0
    rescue => e
      exception e
      exit 1
    end

  end
end
