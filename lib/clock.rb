require "clockwork"
require "monkey_patch"

require "run/log"
require "run/work/redis_helper"

include Clockwork

module Clock
  extend self, Run::Log

  def timers
    [[15.seconds,  "converge"],
     [30.seconds,  "converge_crashed"],
     [1.minutes,   "converge_created"],
     [30.seconds,  "converge_abandoned"],
     [20.seconds,  "counts"],
     [1.minutes,   "garbage_collect"]]
  end

  def setup
    timers.each do |interval, timer|
      every(interval, timer) do
        begin
          Run::Work::RedisHelper.publish("ps.timers", timer: timer)
        rescue => e
          error e
        end
      end
    end
  end

  def main
    loop do
      Clockwork.tick
      sleep(1)
    end
  end

  def run
    setup
    main
    exit 0
  rescue => e
    error e
    exit 1
  end

end
