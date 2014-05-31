namespace :publishers do
  task update: :app do
    Publisher.select(:id).paged_each do |publisher|
      Georelevent::Workers::PublisherPoll.perform_async(publisher.id)
    end
  end
end
