require "run/log"

module Run
  module V0
    module Feed
      extend self, Log

      def routes
        [["hermes", "hermes"]]
      end

      def hermes(data, &blk)
        loop do
          entry = {yo: "dog"}
          yield entry
          sleep 1
        end
      end

    end
  end
end
