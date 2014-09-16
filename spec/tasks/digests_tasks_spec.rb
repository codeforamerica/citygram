require 'spec_helper'
load 'lib/tasks/digests.rake'

describe Rake::Task['digests:send'] do
  it 'queues a job for each digest subscription' do
    email_subscription = create(:subscription, channel: 'email', email_address: 'a@b.cc')
    inactive_email_subscription = create(:subscription, channel: 'email', email_address: 'a@b.cc', unsubscribed_at: DateTime.now)
    sms_subscription = create(:subscription, channel: 'sms', phone_number: '1234567890')
    expect{ subject.invoke }.to change{ Citygram::Workers::Notifier.jobs.count }.by(+1)
  end
end
