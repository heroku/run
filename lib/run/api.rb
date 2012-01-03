require "sinatra"
require "json"

require "run/v0/api"

module Run
  class Api < Sinatra::Base

    helpers do
      def body_json
        @body_json ||= JSON.parse(request.body.read)
      end
    end

    V0::Api.publish_routes.each do |route, name|
      post "/v0/#{route}" do
        V0::Api.method(name).call(body_json)
        200
      end
    end

    V0::Api.call_routes.each do |route, name|
      post "/v0/#{route}" do
        result = V0::Api.method(name).call(body_json)
        [200, {"Content-Type" => "application/json"}, JSON.dump(res: result)]
      end
    end

    get "/health" do
      200
    end

    not_found do
      "This is nowhere to be found."
    end

  end
end
