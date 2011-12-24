require "monkey_patch"

require "run/task"
require "run/log"
require "run/redis_helper"

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

  private

  def main
    Run::RedisHelper.subscribe("ps.timers") do |msg|
      method(msg['timer']).call
    end
  end

end
