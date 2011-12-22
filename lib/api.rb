require "monkey_patch"
require "unicorn"

require "run/log"
require "run/api"

module Api
  extend self, Run::Log

  def main
    Unicorn::HttpServer.new(Run::Api).start.join
  end

  def run
    main
    exit 0
  rescue => e
    error e
    exit 1
  end

end
