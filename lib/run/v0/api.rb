require "sinatra"
require "json"

require "run/log"

module Run
  module V0
    module Api
      extend self, Log

      def routes
        [["visible",        "visible"],
         ["create",         "create"],
         ["docbrown",       "docbrown"],
         ["restart",        "restart"],
         ["restart.ps",     "restart_ps"],
         ["restart.type",   "restart_type"],
         ["idle",           "idle"],
         ["unidle",         "unidle"],
         ["pause",          "pause"],
         ["resume",         "resume"],
         ["stop.ps",        "stop_ps"],
         ["stop.type",      "stop_type"],
         ["destroy",        "destroy"],
         ["update",         "update"],
         ["concurrency",    "concurrency"],
         ["instance.down",  "instance_down"]]
      end

      def visible(vals)
        app_id, rid = vals.values_at('app_id', 'rid')
        notice app_id: app_id, rid: rid
      end

      def create(vals)
        app_id, process_type, rid = vals.values_at('app_id', 'type', 'process_type', 'rid')
        notice app_id: app_id, type: type, process_type: process_type, rid: rid
      end

      def docbrown(vals)
        app_id, rid = vals.values_at('app_id', 'rid')
        notice app_id: app_id, rid: rid
      end

      def restart(vals)
        app_id, unidle, rid = vals.values_at('app_id', 'unidle', 'rid')
        notice app_id: app_id, unidle: unidle, rid: rid
      end

      def restart_ps(vals)
        app_id, ps, rid = vals.values_at('app_id', 'ps', 'rid')
        notice app_id: app_id, ps: ps, rid: rid
      end

      def restart_type(vals)
        app_id, type, rid = vals.values_at('app_id', 'type', 'rid')
        notice app_id: app_id, type: type, rid: rid
      end

      def idle(vals)
        app_id, rid = vals.values_at('app_id', 'rid')
        notice app_id: app_id, rid: rid
      end

      def unidle(vals)
        app_id, rid = vals.values_at('app_id', 'rid')
        notice app_id: app_id, rid: rid
      end

      def pause(vals)
        app_id, type, rid = vals.values_at('app_id', 'type', 'rid')
        notice app_id: app_id, type: type, rid: rid
      end

      def resume(vals)
        app_id, type, rid = vals.values_at('app_id', 'type', 'rid')
        notice app_id: app_id, type: type, rid: rid
      end

      def stop_ps(vals)
        app_id, ps, rid = vals.values_at('app_id', 'ps', 'rid')
        notice app_id: app_id, ps: ps, rid: rid
      end

      def stop_type(vals)
        app_id, type, rid = vals.values_at('app_id', 'type', 'rid')
        notice app_id: app_id, type: type, rid: rid
      end

      def destroy(vals)
        app_id, conds, rid = vals.values_at('app_id', 'conds', 'rid')
        type, process_type = conds.values_at('type', 'process_type')
        notice app_id: app_id, type: type, process_type: process_type, rid: rid
      end

      def update(vals)
        app_id, conds, attrs, rid = vals.values_at('app_id', 'conds', 'attrs', 'rid')
        type, process_type = conds.values_at('type', 'process_type')
        notice app_id: app_id, type: type, process_type: process_type, rid: rid
      end

      def concurrency(vals)
        app_id, conds, attrs, count, rid = vals.values_at('app_id', 'conds', 'attrs', 'conc', 'rid')
        type, process_type = conds.values_at('type', 'process_type')
        notice app_id: app_id, type: type, process_type: process_type, count: count, rid: rid
      end

      def instance_down(vals)
        ip, instance, rid = vals.values_at('ip', 'instance', 'rid')
        noticey ip: ip, instance: instance, rid: rid
      end

    end
  end
end
