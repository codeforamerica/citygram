require 'spec_helper'
load 'lib/tasks/digests.rake'

describe Rake::Task['digests:send'] do
  it 'queues a job for each digest subscription with events' do
    email_subscription = create(:subscription, channel: 'email', email_address: 'a@b.cc')
    create(:event, publisher: email_subscription.publisher, geom: email_subscription.geom)

    sms_subscription = create(:subscription, channel: 'sms', phone_number: '1234567890')
    create(:event, publisher: sms_subscription.publisher, geom: sms_subscription.geom)

    subscription_no_event = create(:subscription, channel: 'email', email_address: 'a@b.cc')

    expect{ subject.invoke }.to change{ Citygram::Workers::Notifier.jobs.count }.by(+1)
  end
end

describe Rake::Task['digests:send_if_digest_day'] do
  before do
    allow(Citygram::DigestHelper).to receive(:digest_day?).and_return(digest_day?)
    allow(Citygram::DigestHelper).to receive(:send)
  end

  context 'digest_day is today' do
    let(:digest_day?) { true }

    it 'sends the digest' do
      subject.invoke
      expect(Citygram::DigestHelper).to have_received(:send)
    end
  end

  context 'digest_day is not today' do
    let(:digest_day?) { false }

    it 'does not send the digest' do
      subject.invoke
      expect(Citygram::DigestHelper).not_to have_received(:send)
    end
  end
end
