require "redis"
require "json"
require "uuidtools"

require "run/log"
require "run/config"

module Run
  module Work
    module RedisHelper
      extend self, Log

      def publish(topic, data)
        header = format_header
        info(header, data, topic: topic) do
          Timeout.timeout(3) do
            conns.shuffle.each do |conn|
              begin
                conn.rpush(topic, JSON.dump(header: header, payload: data))
                info(header, data, topic: topic, event: "published")
                break
              rescue => e
                error e
              end
            end
          end
        end
      end

      def subscribe(topic, &blk)
        finish = Time.now
        loop do
          _, msg = zone_conn.blpop(topic, 0)
          start = Time.now
          data = JSON.parse(msg)
          info(data['header'], data['payload'], topic: topic) do
            begin
              if data['header']['published_on'].delay > data['header']['ttl'].to_i
                info(data['header'], data['payload'], topic: topic, event: "timeout")
              else
                info(data['header'], data['payload'], topic: topic, event: "received")
                yield data['payload']
                info(data['header'], data['payload'], topic: topic, event: "processed")
              end
            rescue => e
              error e
            end
          end
          idle = start - finish
          finish = Time.now
          elapsed = finish - start
          info(data['header'], data['payload'], topic: topic, idle: idle, elapsed: elapsed)
        end
      end

      private

      def new(url)
        Redis.connect(url: url, timeout: 1)
      end

      def urls
        @urls ||= Config.runtime_redis_urls.split(",")
      end

      def conns
        @conns ||= urls.map(&method(:new))
      end

      def zone_url
        @zone_url ||= urls[Config.runtime_redis_zone.ord % urls.size]
      end

      def zone_conn
        @zone_conn ||= new(zone_url)
      end

      def format_header
        { message_id:    UUIDTools::UUID.random_create.to_s,
          published_on:  Time.now.to_i.to_s,
          ttl:           30.to_s }
      end

    end
  end
end
