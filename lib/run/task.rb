require "run/log"

module Run
  module Task
    extend self, Run::Log

    def run
      setup if defined? setup
      main
      teardown if defined? teardown
      exit 0
    rescue => e
      error e
      exit 1
    end

  end
end
