namespace :publishers do
  task update: :app do
    Publisher.select(:id).paged_each do |publisher|
      Georelevent::Workers::PublisherUpdate.perform_async(publisher.id)
    end
  end
end
