require 'faraday'
require 'faraday_middleware'

module ConnectionBuilder
  def self.json(name, opts)
    Faraday.new(opts) do |conn|
      conn.options.timeout = 5
      conn.headers['Content-Type'] = 'application/json'
      conn.response :json
      conn.use :instrumentation, name: name unless Georelevent::App.test?
      conn.adapter Faraday.default_adapter
    end
  end

  class RequestLog < Struct.new(:logger)
    def call(name, starts, ends, _, env)
      url = env[:url]
      http_method = env[:method].to_s.upcase
      duration = ends - starts
      logger.info '[%s] %s %s (%.3f s)' % [url.host, http_method, url.request_uri, duration]
    end

    ActiveSupport::Notifications.subscribe /^request\.(publisher|subscription)\./, new(Georelevent::App.logger)
  end
end
