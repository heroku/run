require "run/config"
require "run/log"
require "run/v0/feed"
require "run/web"

module Run
  class Feed < Web
    include Log

    helpers do
      def credentials
        @credentials ||= [Config.psmgr_url_user, Config.psmgr_alt_url_user].compact
      end

      def chunk(s)
        "#{s.size.to_s(16)}\r\n#{s}\r\n"
      end
    end

    V0::Feed.routes.each do |route, name|
      post "/v0/#{route}" do
        authorized!
        status 202
        headers "Content-Type" => "application/json", "Transfer-Encoding" => "chunked"
        stream do |out|
          V0::Feed.method(name).call(data) do |entry|
            out << chunk("#{entry}\r\n")
          end
          out << chunk("")
        end
      end
    end

  end
end
