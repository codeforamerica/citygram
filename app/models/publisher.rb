require 'lib/connection_builder'

module Georelevent
  module Models
    class Publisher < Sequel::Model
      one_to_many :subscriptions
      one_to_many :events

      set_allowed_columns :title, :endpoint

      def connection
        ConnectionBuilder.json(url: endpoint)
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
