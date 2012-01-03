require "monkey_patch"
require "timeout"

require "run/task"
require "run/log"
require "run/data_helper"
require "run/redis_helper"
require "run/timers"

module Timers
  extend self, Run::Task, Run::Log

  def init
    Timeout.timeout(3) do
      Run::DataHelper.conn.test_connection
      Run::RedisHelper.zone_conn.ping
    end
  end

  def main
    Run::RedisHelper.subscribe("ps.timers") do |msg|
      route = Run::Timers.routes[msg['timer']]
      Run::Timers.method(route).call if route
    end
  end

end
