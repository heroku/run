require "monkey_patch"
require "unicorn"

require "run/log"
require "run/config"
require "run/feed"

module Feed
  extend self, Run::Log

  def server
    @server ||= Unicorn::HttpServer.new(Run::Feed, options)
  end

  def main
    info port: port
    server.start.join
  end

  def run
    main
    exit 0
  rescue => e
    error e
    exit 1
  end

  private

  def port
    @port ||= Run::Config.port || 9090
  end

  def options
    { listeners:         ["0.0.0.0:#{port}"],
      worker_processes:  4,
      preload_app:       true,
      timeout:           4.hours }
  end

end
