require 'spec_helper'

describe Georelevent::Models::Publisher do
  it 'whitelists mass-assignable columns' do
    expect(Publisher.allowed_columns).to eq [:title, :endpoint]
  end
end
