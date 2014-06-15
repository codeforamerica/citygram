require 'spec_helper'
load 'lib/tasks/publishers.rake'

describe Rake::Task['publishers:update'] do
  it 'queues a job for each publisher' do
    create_list(:publisher, 3)
    expect{ subject.invoke }.to change{ Citygram::Workers::PublisherPoll.jobs.count }.by(+3)
  end
end
