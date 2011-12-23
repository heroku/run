require "sequel"

module Run
  module DataHelper
    extend self, Log

    def lock(id)
      Timeout.timeout(3) do
        conn["SELECT pg_try_advisory_lock(#{id})"].get
      end
    end

    private

    def connect
      Sequel.connect(Config.psmgr_database_url, encoding: "unicode") do |conn|
        conn.run("SET synchronous_commit TO 'off'")
        conn
      end
    end

    def conn
      @conn ||= connect
    end

  end
end
