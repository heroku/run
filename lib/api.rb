require "monkey_patch"
require "unicorn"

require "run/task"
require "run/log"
require "run/config"
require "run/api"

module Api
  extend self, Run::Task, Run::Log

  private

  def port
    @port ||= Run::Config.port || 8080
  end

  def to_options
    { listeners:         ["0.0.0.0:#{port}"],
      worker_processes:  4,
      preload_app:       true,
      timeout:           15.seconds }
  end

  def server
    @server ||= Unicorn::HttpServer.new(Run::Api, to_options)
  end

  def main
    info port: port
    server.start.join
  end

end
