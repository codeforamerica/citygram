require 'faraday'
require 'faraday_middleware'

module ConnectionBuilder
  def self.json(name, opts)
    Faraday.new(opts) do |conn|
      conn.options.timeout = 5
      conn.headers['Content-Type'] = 'application/json'
      conn.response :json
      conn.use :instrumentation, name: name
      conn.adapter Faraday.default_adapter
    end
  end
end

if !Georelevent::App.test?
  ActiveSupport::Notifications.subscribe(/^request\.(publisher|subscription)\./) do |name, starts, ends, _, env|
    url = env[:url]
    http_method = env[:method].to_s.upcase
    duration = ends - starts
    Georelevent.logger.info '[%s] %s %s (%.3f s)' % [url.host, http_method, url.request_uri, duration]
  end
end
