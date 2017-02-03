namespace :subscriptions do
  desc "Unsubscribe subscriptions with same publisher, channel, geom, and (email or phone)"
  task :deduplicate, [:city, :publisher_title] => :app do |t, args|
    unless args.city && args.publisher_title
      fail 'city and publisher_title required'
    end

    publisher = Publisher.where(city: args.city, title: args.publisher_title).first
    Subscription.duplicates.where(publisher_id: publisher.id).map do |subscription|
      puts "Unsubscribing #{subscription.id}"
      subscription.unsubscribe!
    end
  end
end
