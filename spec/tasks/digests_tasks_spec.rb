require 'spec_helper'
load 'lib/tasks/digests.rake'

describe Rake::Task['digests:send'] do
  it 'queues a job for each digest subscription' do
    publisher = create(:publisher)
    email_subscription = create(:subscription, channel: 'email', email_address: 'a@b.cc', publisher: publisher)
    sms_subscription = create(:subscription, channel: 'sms', phone_number: '1234567890', publisher: publisher)
    expect{ subject.invoke }.to change{ Citygram::Workers::Notifier.jobs.count }.by(+1)
  end
end
