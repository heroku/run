require "monkey_patch"
require "timeout"

require "run/task"
require "run/log"
require "run/data_helper"
require "run/redis_helper"

autoload :Logical,   "run/logical"
autoload :Physical,  "run/physical"

module Timers
  extend self, Run::Task, Run::Log

  def converge
    info do
    end
  end

  def converge_created
    info do
    end
  end

  def converge_crashed
    info do
    end
  end

  def converge_abandoned
    info do
    end
  end

  def counts
    info do
    end
  end

  def garbage_collect
    info do
    end
  end

  def init
    Timeout.timeout(3) do
      Run::DataHelper.conn.test_connection
      Run::RedisHelper.zone_conn.ping
    end
  end

  def main
    Run::RedisHelper.subscribe("ps.timers") do |msg|
      method(msg['timer']).call
    end
  end

end
