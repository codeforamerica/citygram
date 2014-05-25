module Georelevent
  module Models
    class Publisher < Sequel::Model
      one_to_many :subscriptions
      one_to_many :events

      set_allowed_columns :title, :endpoint

      def connection
        Faraday.new(url: endpoint) do |conn|
          conn.options.timeout = 5
          conn.headers['Content-Type'] = 'application/json'
          conn.response :json
          conn.adapter Faraday.default_adapter
        end
      end

      def validate
        super
        validates_presence [:title, :endpoint]
        validates_url :endpoint
      end
    end
  end
end
