require 'spec_helper'

describe Citygram::Services::ConnectionBuilder do
  subject { Citygram::Services::ConnectionBuilder.json('test.connection', url: url) }
  let(:url) { Faker::Internet.uri('https') }

  it 'connects to the given url' do
    expect(subject.build_url.to_s).to match url
  end

  it 'sets a reasonable timeout' do
    expect(subject.options.timeout).to eq 5
  end

  it 'parses the response as JSON' do
    stub_request(:get, url).
      with(headers: {'Content-Type'=>'application/json'}).
      to_return(status: 200, body: fixture('cmpd-traffic-incidents.geojson'))

    body = subject.get.body
    expect(body).to be_kind_of(Hash)
  end
end
