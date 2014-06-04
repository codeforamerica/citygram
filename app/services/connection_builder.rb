require 'faraday'
require 'faraday_middleware'

module ConnectionBuilder
  def self.json(opts)
    Faraday.new(opts) do |conn|
      conn.options.timeout = 5
      conn.headers['Content-Type'] = 'application/json'
      conn.response :json
      conn.adapter Faraday.default_adapter
    end
  end
end
