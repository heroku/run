require "monkey_patch"

require "run/log"
require "run/redis_helper"

module Timers
  extend self, Run::Log

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

  def main
    Run::RedisHelper.subscribe("ps.timers") do |msg|
      method(msg['timer']).call
    end
  end

  def run
    main
    exit 0
  rescue => e
    error e
    exit 1
  end

end
