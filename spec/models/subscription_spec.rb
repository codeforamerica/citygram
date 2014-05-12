require 'spec_helper'

describe Georelevent::Models::Subscription do
  it 'roundtrips geojson-structured data with postgis types' do
    line_string = {"type"=>"LineString","coordinates"=>[[102.0,0.0],[103.0,1.0],[104.0,0.0],[105.0,1.0]]}
    subscription_id = create(:subscription, geom: line_string).id
    subscription = Subscription.first!(id: subscription_id)
    expect(subscription.geom).to eq line_string
  end
end
