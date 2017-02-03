require 'spec_helper'
load 'lib/tasks/subscriptions.rake'

describe Rake::Task['subscriptions:deduplicate'] do
  it 'deduplicates for a specific publisher' do
    subscription = create(:subscription, channel: 'email', email_address: 'a@b.cc')
    dupe = create(:subscription,
      publisher_id: subscription.publisher_id,
      geom: subscription.geom,
      channel: subscription.channel,
      email_address: subscription.email_address)

    diff_publisher = create(:subscription,
      publisher_id: create(:publisher).id,
      geom: subscription.geom,
      channel: subscription.channel,
      email_address: subscription.email_address)
    diff_publisher_dupe = create(:subscription,
      publisher_id: diff_publisher.publisher_id,
      geom: diff_publisher.geom,
      channel: diff_publisher.channel,
      email_address: diff_publisher.email_address)

    expect {
      subject.invoke(subscription.publisher.city, subscription.publisher.title)
    }.to change{ Subscription.active.count }.by(-1)
  end
end
