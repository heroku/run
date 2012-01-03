require "monkey_patch"
require "timeout"
require "unicorn"

require "run/task"
require "run/log"
require "run/config"
require "run/api"
require "run/data_helper"

module Api
  extend self, Run::Task, Run::Log

  def init
    Timeout.timeout(3) do
      Run::DataHelper.conn.test_connection
    end
  end

  def port
    @port ||= Run::Config.port || 8080
  end

  def server
    @server ||= Unicorn::HttpServer.new(Run::Api, to_options)
  end

  def main
    notice port: port
    server.start.join
  end

  private

  def to_options
    { listeners:         ["0.0.0.0:#{port}"],
      worker_processes:  4,
      timeout:           15.seconds }
  end

end
