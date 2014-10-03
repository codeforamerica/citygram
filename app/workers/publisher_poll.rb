require 'app/services/connection_builder'
require 'app/services/publisher_update'

module Citygram::Workers
  class PublisherPoll
    include Sidekiq::Worker
    sidekiq_options retry: 5

    MAX_PAGE_NUMBER = 10
    NEXT_PAGE_HEADER = 'Next-Page'.freeze

    def perform(publisher_id, url, page_number = 1)
      # fetch publisher record or raise
      publisher = Publisher.first!(id: publisher_id)

      # prepare a connection for the given url
      connection = Citygram::Services::ConnectionBuilder.json("request.publisher.#{publisher.id}", url: url)

      # execute the request or raise
      response = connection.get

      # save any new events
      feature_collection = response.body
      Citygram::Services::PublisherUpdate.call(feature_collection.fetch('features'), publisher)

      # OPTIONAL PAGINATION:
      #
      # iff successful to this point, and a next page is given
      # queue up a job to retrieve the next page
      #
      next_page = response.headers[NEXT_PAGE_HEADER]
      if next_page.present? && valid_next_page?(next_page, url) && page_number < MAX_PAGE_NUMBER
        self.class.perform_async(publisher_id, next_page, page_number + 1)
      end
    end

    private

    def valid_next_page?(next_page, current_page)
      next_page = URI.parse(next_page)
      current_page = URI.parse(current_page)

      next_page.host == current_page.host &&
        next_page != current_page
    end
  end
end
