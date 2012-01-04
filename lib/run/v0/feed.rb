require "json"

require "run/log"

module Run
  module V0
    module Feed
      extend self, Log

      def routes
        [["hermes",  "hermes"],
         ["apollo",  "apollo"]]
      end

      def hermes(data, &blk)
        loop do
          entry = {yo: "dog"}
          yield JSON.dump(entry)
          yield ""
          sleep 1
        end
      end

      def apollo(data, &blk)
        loop do
          entry = {dog: "yo"}
          yield JSON.dump(entry)
          yield ""
          sleep 1
        end
      end

    end
  end
end
