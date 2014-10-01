namespace :publishers do
  task update: :app do
    Publisher.active.select(:id).paged_each do |publisher|
      Citygram::Workers::PublisherPoll.perform_async(publisher.id)
    end
  end
end
