require "monkey_patch"
require "timeout"
require "unicorn"

require "run/task"
require "run/log"
require "run/config"
require "run/feed"
require "run/data_helper"

module Feed
  extend self, Run::Task, Run::Log

  def init
    Timeout.timeout(3) do
      Run::DataHelper.conn.test_connection
    end
  end

  def port
    @port ||= Run::Config.port || 9090
  end

  def server
    @server ||= Unicorn::HttpServer.new(Run::Feed, to_options)
  end

  def main
    notice port: port
    server.start.join
  end

  private

  def to_options
    { listeners:         ["0.0.0.0:#{port}"],
      worker_processes:  4,
      timeout:           4.hours }
  end

end
