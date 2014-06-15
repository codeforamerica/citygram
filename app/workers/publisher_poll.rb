require 'app/services/publisher_update'

module Citygram
  module Workers
    class PublisherPoll
      include Sidekiq::Worker
      sidekiq_options retry: 5

      def perform(publisher_id)
        publisher = Publisher.first!(id: publisher_id)
        feature_collection = publisher.connection.get.body
        Citygram::Services::PublisherUpdate.call(feature_collection.fetch('features'), publisher)
      end
    end
  end
end
