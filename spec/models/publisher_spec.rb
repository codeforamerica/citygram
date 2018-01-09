require 'spec_helper'

describe Citygram::Models::Publisher do
  it 'has many subscriptions' do
    type = Publisher.association_reflections[:subscriptions][:type]
    expect(type).to eq :one_to_many
  end

  it 'has many events' do
    type = Publisher.association_reflections[:events][:type]
    expect(type).to eq :one_to_many
  end

  it 'whitelists mass-assignable columns' do
    expect(Publisher.allowed_columns.sort).to eq [].sort
  end

  it 'requires a title' do
    publisher = build(:publisher, title: '')
    expect(publisher).not_to be_valid
  end

  it 'requires a fully qualified endpoint' do
    publisher = build(:publisher, endpoint: 'foo.com/events')
    expect(publisher).not_to be_valid
  end

  it 'allows a null event display endpoint' do
    publisher = build(:publisher)
    publisher.event_display_endpoint = nil
    expect(publisher).to be_valid
  end

  it 'validates fully qualified event display endpoint if present' do
    publisher = build(:publisher, event_display_endpoint: 'foo.com/events')
    expect(publisher).not_to be_valid
  end

  it 'requires a unique endpoint' do
    publisher = create(:publisher)
    other = build(:publisher, endpoint: publisher.endpoint)
    expect(other).not_to be_valid
  end

  it 'requires a city' do
    publisher = build(:publisher, city: '')
    expect(publisher).not_to be_valid
  end
end
