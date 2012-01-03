require "sinatra"
require "json"

require "run/log"
require "run/v0/api"

module Run
  class Api < Sinatra::Base
    include Log

    disable :show_exceptions, :dump_errors

    helpers do
      def data
        @data ||= JSON.parse(request.body.read)
      end
    end

    V0::Api.routes.each do |route, name|
      post "/v0/#{route}" do
        result = V0::Api.method(name).call(data)
        [200, {"Content-Type" => "application/json"}, result && JSON.dump(res: result) || ""]
      end
    end

    get "/health" do
      [200, {"Content-Type" => "application/json"}, ""]
    end

    error do
      exception env['sinatra.error']
      [500, {"Content-Type" => "application/json"}, ""]
    end

    not_found do
      [404, {"Content-Type" => "application/json"}, ""]
    end

  end
end
