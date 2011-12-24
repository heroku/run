require "monkey_patch"
require "unicorn"

require "run/task"
require "run/log"
require "run/config"
require "run/feed"

module Feed
  extend self, Run::Task, Run::Log

  private

  def port
    @port ||= Run::Config.port || 9090
  end

  def to_options
    { listeners:         ["0.0.0.0:#{port}"],
      worker_processes:  4,
      preload_app:       true,
      timeout:           4.hours }
  end

  def server
    @server ||= Unicorn::HttpServer.new(Run::Feed, to_options)
  end

  def main
    info port: port
    server.start.join
  end

end
