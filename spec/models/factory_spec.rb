require 'spec_helper'

describe 'Factories' do
  FactoryGirl.factories.map(&:name).each do |name|
    subject { build(name) }

    it "builds a valid #{name} object" do
      should be_valid
    end
  end
end
