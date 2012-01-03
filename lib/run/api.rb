require "run/config"
require "run/log"
require "run/v0/api"
require "run/web"

module Run
  class Api < Web
    include Log

    helpers do
      def credentials
        @credentials ||= [Config.psmgr_url_user, Config.psmgr_alt_url_user].compact
      end
    end

    V0::Api.routes.each do |route, name|
      post "/v0/#{route}" do
        authorized!
        if result = V0::Api.method(name).call(data)
          [200, {"Content-Type" => "application/json"}, JSON.dump(res: result)]
        else
          200
        end
      end
    end

  end
end
