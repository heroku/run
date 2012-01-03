require "run/log"

autoload :Logical,   "run/logical"
autoload :Physical,  "run/physical"

module Run
  module Timers
    extend self, Log

    def routes
      ["converge"            => "converge",
       "converge.created"    => "converge_created",
       "converge.crashed"    => "converge_crashed",
       "converge.abandoned"  => "converge_abandoned",
       "counts"              => "counts",
       "garbage.collect"     => "garbage_collect"]
    end

    def converge
      notice do
      end
    end

    def converge_created
      notice do
      end
    end

    def converge_crashed
      notice do
      end
    end

    def converge_abandoned
      notice do
      end
    end

    def counts
      notice do
      end
    end

    def garbage_collect
      notice do
      end
    end

  end
end
