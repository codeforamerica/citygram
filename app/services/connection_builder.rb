require 'faraday'
require 'faraday_middleware'

module Citygram
  module Services
    module ConnectionBuilder
      def self.json(name, opts)
        Faraday.new(opts) do |conn|
          conn.options.timeout = 10
          conn.headers['Accept'] = 'application/json'
          conn.response :json
          conn.response :raise_error
          conn.use :instrumentation, name: name
          conn.adapter Faraday.default_adapter
        end
      end

      class RequestLog < Struct.new(:logger)
        Dataset = DB[:http_requests]

        def call(name, starts, ends, _, env)
          url = env[:url]
          http_method = env[:method].to_s.upcase
          duration_in_seconds = ends - starts
          duration_in_milliseconds = (duration_in_seconds*1000).to_i

          logger.info '[%s] %s %s (%.3f s)' % [url.host, http_method, url.request_uri, duration_in_seconds]

          Dataset.insert(
            scheme:          url.scheme,
            userinfo:        url.userinfo,
            host:            url.host,
            port:            url.port,
            path:            url.path,
            query:           url.query,
            fragment:        url.fragment,
            method:          http_method,
            response_status: env[:status],
            duration:        duration_in_milliseconds,
            started_at:      starts,
          )
        rescue => e
          logger.error e.message
        end
      end
    end
  end
end
