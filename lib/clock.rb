require "clockwork"
require "monkey_patch"

require "run/task"
require "run/log"
require "run/data_helper"
require "run/redis_helper"

include Clockwork

module Clock
  extend self, Run::Task, Run::Log

  private

  def to_timers
    [[15.seconds,  "converge"],
     [30.seconds,  "converge_crashed"],
     [1.minutes,   "converge_created"],
     [30.seconds,  "converge_abandoned"],
     [20.seconds,  "counts"],
     [1.minutes,   "garbage_collect"]]
  end

  def setup
    to_timers.each do |interval, timer|
      every(interval, timer) do
        begin
          Timeout.timeout(3) do
            Run::RedisHelper.publish("ps.timers", timer: timer)
          end
        rescue => e
          error e
        end
      end
    end
  end

  def clock?
    id = Time.now.to_i / 1.day.to_i
    Timeout.timeout(3) do
      Run::DataHelper.lock(id)
    end
  end

  def main
    loop do
      Clockwork.tick if clock = clock?
      info clock: clock
      sleep(1)
    end
  end

end
