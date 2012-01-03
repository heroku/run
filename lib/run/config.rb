require "uri"

module Run
  module Config
    extend self

    def port
      @port ||= env("PORT")
    end

    def psmgr_url
      @psmgr_url ||= env!("PSMGR_URL")
    end

    def psmgr_url_user
      @psmgr_url_user ||= psmgr_url && URI.parse(psmgr_url).user
    end

    def psmgr_alt_url
      @psmgr_alt_url ||= env("PSMGR_ALT_URL")
    end

    def psmgr_alt_url_user
      @psmgr_alt_url_user ||= psmgr_alt_url && URI.parse(psmgr_alt_url).user
    end

    def psmgr_database_url
      @psmgr_database_url ||= env!("PSMGR_DATABASE_URL")
    end

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
