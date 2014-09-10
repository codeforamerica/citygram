namespace :digests do
  task send: :app do
    Subscription.where(channel: 'email').all do |subscription|
      Citygram::Workers::Notifier.perform_async(subscription.id, nil)
    end
  end
end
