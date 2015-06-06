require 'digest/md5'
require 'json'
require 'faraday'
require 'net/http'
require 'sinatra'



get '/orlando-historical-landmarks' do
	url = URI('https://brigades.opendatanetwork.com/resource/hzkr-id6u.json')

	response = Net::HTTP.get(url)

	collection = JSON.parse(response)

	features = collection.map do |record|
		id = Digest::MD5.hexdigest(record['name'])
		title = "The Orlando historical landmark #{record['name']} is located at #{record['address']}."
		{
			'id' => id,
			'type' => 'Feature',
			'properties' => record.merge('title' => title),
			'geometry' =>
			{
				'type' => 'Point',
				'coordinates' =>
				[
					'latitude' => record['latitude'].to_f,
					'longitude' => record['longitude'].to_f
				]
			}
		}
	end

	content_type :json
	JSON.pretty_generate('type' => 'FeatureCollection', 'features' => features)
end



get '/police-dispatch-calls' do
	url = URI('https://brigades.opendatanetwork.com/resource/ngeg-3ist.json')
	url.query = Faraday::Utils.build_query(
		'$order' => 'referenceid DESC',
		'$limit' => 100,
		'$where' => "isgeocoded = 'true'" +
					" AND geopoint IS NOT NULL" +
					" AND location IS NOT NULL"
	)

	connection = Faraday.new(url: url.to_s)
	response = connection.get

	collection = JSON.parse(response.body)

	features = collection.map do |record|
		title = "A #{record['description']} has occurred at #{record['location']} on #{record['calltime']}."
		{
			'id' => record['referenceid'],
			'type' => 'Feature',
			'properties' => record.merge('title' => title),
			'geometry' =>
			{
				'type' => 'Point',
				'coordinates' =>
				[
					'longitude' => record['location_1']['longitude'].to_f,
					'latitude' => record['location_1']['latitude'].to_f
				]
			}
		}
	end

	content_type :json
	JSON.pretty_generate('type' => 'FeatureCollection', 'features' => features)
end

