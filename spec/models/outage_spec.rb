require 'spec_helper'

describe Citygram::Models::Outage do

  it 'has a valid factory' do
    outage = build(:outage)
    expect(outage).to be_valid
  end
  
  it 'requires a publisher' do
    outage = build(:outage, publisher: nil)
    expect(outage).not_to be_valid
  end  

end
