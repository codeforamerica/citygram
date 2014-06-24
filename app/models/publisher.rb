module Citygram
  module Models
    class Publisher < Sequel::Model
      one_to_many :subscriptions
      one_to_many :events

      plugin Citygram::Models::Plugins::URLValidationHelpers
      set_allowed_columns :title, :endpoint

      def connection
        Citygram::Services::ConnectionBuilder.json("request.publisher.#{id}", url: endpoint)
      end

      def validate
        super
        validates_presence [:title, :endpoint]
        validates_url :endpoint
        validates_unique :title
        validates_unique :endpoint
      end
    end
  end
end
