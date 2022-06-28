require 'spec_helper'

describe 'Factories' do
  FactoryBot.factories.map(&:name).each do |name|
    subject { build(name) }

    it "builds a valid #{name} object" do
      is_expected.to be_valid
    end
  end
end
