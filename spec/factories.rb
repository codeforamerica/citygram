require 'factory_girl'
require 'spec/support/fixture_helpers'

FactoryGirl.define do
  factory :publisher, class: Citygram::Models::Publisher do
    sequence(:title) { |n| "Title-#{n}"  }
    sequence(:endpoint) { |n| "https://www.example.com/path-#{n}" }
    sequence(:city) { |n| "City-#{n}" }
    icon 'balloons.png'
    active true
    sms_credentials
  end

  factory :event, class: Citygram::Models::Event do
    publisher
    sequence(:title) { |n| "Event-#{n}"  }
    description { |event| "An event description for: #{event.title}" }
    feature_id { SecureRandom.hex(10) }
    geom FixtureHelpers.fixture('disjoint-geom.geojson')
  end
  
  factory :outage, class: Citygram::Models::Outage do
    publisher
  end
  
  factory :sms_credentials, class: Citygram::Models::SmsCredentials do
    credential_name "test-credential"
    from_number "15555555555"
    sequence(:account_sid) { |n| "dev-account-sid-#{n}"  }
    auth_token "dev-auth-token"
  end  

  factory :subscription, class: Citygram::Models::Subscription do
    publisher
    sequence(:webhook_url) { |n| "https://www.example.com/path-#{n}" }
    channel 'webhook'
    geom FixtureHelpers.fixture('subject-geom.geojson')
  end
end
