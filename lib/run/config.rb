module Run
  module Config
    extend self

    def runtime_redis_urls
      @runtime_redis_urls ||= env!("RUNTIME_REDIS_URLS")
    end

    def runtime_redis_zone
      @runtime_redis_zone ||= env("RUNTIME_REDIS_ZONE")
    end

    private

    def env(k)
      ENV[k] unless ENV[k].blank?
    end

    def env!(k)
      env(k) || raise("missing_environment=#{k}")
    end

  end
end