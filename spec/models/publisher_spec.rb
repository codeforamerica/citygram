require 'spec_helper'

describe Georelevent::Models::Publisher do
  describe '#connection' do
    it 'connects to the endpoint' do
      publisher = build(:publisher)
      connection = publisher.connection
      expect(connection.build_url.to_s).to match publisher.endpoint
    end

    it 'sets a reasonable timeout' do
      publisher = build(:publisher)
      connection = publisher.connection
      expect(connection.options.timeout).to eq 5
    end
  end

  it 'has many subscriptions' do
    type = Publisher.association_reflections[:subscriptions][:type]
    expect(type).to eq :one_to_many
  end

  it 'has many events' do
    type = Publisher.association_reflections[:events][:type]
    expect(type).to eq :one_to_many
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
