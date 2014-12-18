namespace :digests do
  task send: :app do
    Subscription.notifiables.where(channel: 'email').paged_each do |subscription|
      if subscription.has_events?
        Citygram::Workers::Notifier.perform_async(subscription.id, nil)
      end
    end
  end
end
