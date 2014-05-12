FactoryGirl.define do
  factory :event, class: Georelevent::Models::Event do
    title { Faker::Lorem.sentence(3) }
    description { Faker::Lorem.paragraph(2) }
    geom { {"type"=>"Point","coordinates"=>[Faker::Geolocation.lat,Faker::Geolocation.lng]} }
  end

  factory :subscription, class: Georelevent::Models::Subscription do
    geom { {"type"=>"Polygon","coordinates"=>[[[100.0, 0.0],[101.0, 0.0],[101.0, 1.0],[100.0,1.0],[100.0,0.0]]]} }
  end
end
