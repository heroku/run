require "sinatra"
require "json"

module Run
  class Feed < Sinatra::Base

    get "/" do
      status 202
      headers "Content-Type" => "application/json", "Transfer-Encoding" => "chunked"
      stream do |out|
        loop do
          data = JSON.dump(yo: "dog")
          out << "#{data.size.to_s(16)}\r\n#{data}\r\n"
          sleep 1
        end
      end
    end

    get "/health" do
    end

  end
end
