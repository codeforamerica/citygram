require 'spec_helper'

describe Citygram::Services::Channels::Email do
  subject { Citygram::Services::Channels::Email }

  include Mail::Matchers

  let(:subscription) { create(:subscription, channel: 'email', email_address: to_email_address) }

  let(:to_email_address) { Faker::Internet.email }
  let(:from_email_address) { ENV.fetch('SMTP_FROM_ADDRESS') }

  around do |example|
    original = Pony.options.dup
    Pony.options = Pony.options.merge(via: :test)
    example.run
    Pony.options = original
  end

  context 'success' do
    before do
      subject.call(subscription, nil)
    end

    it { is_expected.to have_sent_email.from(from_email_address) }
    it { is_expected.to have_sent_email.to(to_email_address) }
    it { is_expected.to have_sent_email.with_subject("Citygram #{subscription.publisher.title} notifications") }

  end

  context 'rendering digest' do
    it 'renders the events for the subscription' do
      subscription = create(:subscription, geom: fixture('subject-geom.geojson'))
      event = create(:event, publisher: subscription.publisher, geom: fixture('intersecting-geom.geojson'))
      expect(subject.new(subscription).body).to match(event.title)
    end
  end

  context 'failure' do
    # TODO
  end
end
