require "redis"
require "json"
require "uuidtools"

require "run/log"
require "run/config"

module Run
  module RedisHelper
    extend self, Log

    def publish(topic, data)
      header = to_header
      info header, data, topic: topic do
        conns.shuffle.each do |conn|
          begin
            conn.rpush(topic, JSON.dump(header: header, payload: data))
            info header, data, topic: topic, event: "published"
            break
          rescue => e
            error e
          end
        end
      end
    end

    def subscribe(topic, &blk)
      finish = Time.now
      loop do
        _, msg = zone_conn.blpop(topic, 0)
        start = Time.now
        payload = JSON.parse(msg)
        header, data = payload['header'], payload['payload']
        published_on, ttl = header['published_on'], header['ttl']
        info header, data, topic: topic do
          begin
            if published_on.delay > ttl.to_i
              info header, data, topic: topic, event: "timeout"
            else
              info header, data, topic: topic, event: "received"
              yield data
              info header, data, topic: topic, event: "processed"
            end
          rescue => e
            error e
          end
        end
        idle = start - finish
        finish = Time.now
        elapsed = finish - start
        info header, data, topic: topic, idle: idle, elapsed: elapsed
      end
    end

    private

    def connect(url)
      Redis.connect(url: url, timeout: 1)
    end

    def urls
      @urls ||= Config.runtime_redis_urls.split(",")
    end

    def conns
      @conns ||= urls.map(&method(:connect))
    end

    def zone_url
      @zone_url ||= urls[Config.runtime_redis_zone.ord % urls.size]
    end

    def zone_conn
      @zone_conn ||= connect(zone_url)
    end

    def to_header
      { message_id:    UUIDTools::UUID.random_create.to_s,
        published_on:  Time.now.to_i.to_s,
        ttl:           30.to_s }
    end

  end
end
