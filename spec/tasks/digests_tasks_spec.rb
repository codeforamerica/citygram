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
