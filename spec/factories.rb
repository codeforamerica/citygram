FactoryGirl.define do
  factory :publisher, class: Citygram::Models::Publisher do
    title { Faker::Lorem.sentence(3) }
    endpoint { Faker::Internet.uri('https') }
  end

  factory :event, class: Citygram::Models::Event do
    publisher
    title { Faker::Lorem.sentence(3) }
    description { Faker::Lorem.paragraph(2) }
    feature_id { SecureRandom.hex(10) }
    geom do
      JSON.generate({
        "type"=>"Point",
        "coordinates"=>[Faker::Geolocation.lat,Faker::Geolocation.lng]
      })
    end
  end

  factory :subscription, class: Citygram::Models::Subscription do
    publisher
    contact { Faker::Internet.uri('https') }
    channel 'webhook'
    geom do
      JSON.generate({
        "type"=>"Polygon",
        "coordinates"=>[[[100.0, 0.0],[101.0, 0.0],[101.0, 1.0],[100.0,1.0],[100.0,0.0]]]
      })
    end
  end
end
