require "monkey_patch"
require "unicorn"

require "run/log"
require "run/config"
require "run/api"

module Api
  extend self, Run::Log

  def main
    options = format_options
    info options
    Unicorn::HttpServer.new(Run::Api, options).start.join
  end

  def run
    main
    exit 0
  rescue => e
    error e
    exit 1
  end

  private

  def port
    @port ||= Run::Config.port || 8080
  end

  def format_options
    { listeners:         ["0.0.0.0:#{port}"],
      worker_processes:  4,
      timeout:           15.seconds }
  end

end
