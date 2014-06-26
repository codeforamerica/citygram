require 'app/services/connection_builder'
require 'app/services/publisher_update'

module Citygram
  module Workers
    class PublisherPoll
      include Sidekiq::Worker
      sidekiq_options retry: 5

      def perform(publisher_id)
        publisher = Publisher.first!(id: publisher_id)
        connection = Citygram::Services::ConnectionBuilder.json("request.publisher.#{publisher.id}", url: publisher.endpoint)
        feature_collection = connection.get.body
        Citygram::Services::PublisherUpdate.call(feature_collection.fetch('features'), publisher)
      end
    end
  end
end
