require 'app/services/publisher_update'

module Georelevent
  module Workers
    class PublisherPoll
      include Sidekiq::Worker
      sidekiq_options retry: 5

      def perform(publisher_id)
        publisher = Publisher.first!(id: publisher_id)
        feature_collection = publisher.connection.get.body
        Georelevent::Services::PublisherUpdate.call(feature_collection.fetch('features'), publisher)
      end
    end
  end
end
