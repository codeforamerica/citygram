desc 'Compile city statistics'
task stats: :app do
  cities = Publisher.group_and_count(:city)
  puts "#{cities.count} cities"
  cities.each do |pub|
    city = pub.city
    dataset_count = pub.values[:count]
    puts "#{city}: #{dataset_count} datasets"
    city_pubs = Publisher.select(:id).where(city: city)
    subs = Subscription.filter(publisher_id: city_pubs).group_and_count(:channel)
    puts subs.collect {|sub_type|
      "(#{sub_type.values[:count]} #{sub_type.channel} subscriptions)"
    }.join(" ")
    txt_subs = Subscription.filter(publisher_id: city_pubs).filter(channel: 'sms')
    txt_count = txt_subs.inject(0) do |txts, txt_sub|
      txts += Event.from_subscription(txt_sub, after_date: txt_sub.created_at).count
    end
    puts "#{txt_count} SMS messages delivered"
    email_subs = Subscription.filter(publisher_id: city_pubs).filter(channel: 'email')
    email_evt_count = email_subs.inject(0) do |es, e_sub|
      es += Event.from_subscription(e_sub, after_date: e_sub.created_at).count
    end
    email_count = email_subs.inject(0) do |es, e_sub|
      es += ((Time.now - e_sub.created_at) / 1.week).to_i
    end
    puts "#{email_evt_count} events digested in #{email_count} emails"
  end
end
