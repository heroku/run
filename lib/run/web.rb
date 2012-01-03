require "sinatra"
require "json"
require "timeout"

require "run/log"
require "run/util"
require "run/data_helper"

module Run
  class Web < Sinatra::Base
    include Log

    disable :show_exceptions, :dump_errors, :logging

    helpers do
      def data
        @data ||= JSON.parse(request.body.read)
      end

      def auth
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
      end

      def authorized?
        auth.provided? && auth.basic? && auth.credentials && credentials.include?(auth.credentials.first)
      end

      def authorized!
        throw :halt, 401 if not authorized?
      end
    end

    get "/health" do
      Timeout.timeout(3) do
        if Util.deny?("api")
          503
        elsif not DataHelper.conn.test_connection
          500
        else
          200
        end
      end
    end

    error do
      exception env['sinatra.error']
      500
    end

    not_found do
      [404, ""]
    end

  end
end
