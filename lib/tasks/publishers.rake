namespace :publishers do
  task update: :app do
    Publisher.active.select(:id, :endpoint).paged_each do |publisher|
      Citygram::Workers::PublisherPoll.perform_async(publisher.id, publisher.endpoint)
    end
  end
end
