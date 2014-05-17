require 'spec_helper'

describe Georelevent::Models::Publisher do
  it 'has many subscriptions' do
    publisher = create(:publisher)
    subscription = create(:subscription, publisher: publisher)
    expect(publisher.subscriptions).to eq [subscription]
  end

  it 'has many events' do
    publisher = create(:publisher)
    event = create(:event, publisher: publisher)
    expect(publisher.events).to eq [event]
  end

  it 'whitelists mass-assignable columns' do
    expect(Publisher.allowed_columns).to eq [:title, :endpoint]
  end

  it 'requires a title' do
    publisher = build(:publisher, title: '')
    expect(publisher).not_to be_valid
  end

  it 'requires a fully qualified endpoint' do
    publisher = build(:publisher, endpoint: 'foo.com/events')
    expect(publisher).not_to be_valid
  end
end
