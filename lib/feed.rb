require "monkey_patch"
require "unicorn"

require "run/log"
require "run/feed"

module Feed
  extend self, Run::Log

  def main
    Unicorn::HttpServer.new(Run::Api, timeout: 2.hours).start.join
  end

  def run
    main
    exit 0
  rescue => e
    error e
    exit 1
  end

end
