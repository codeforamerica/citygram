module Citygram::Routes
  class Publishers < Grape::API
    version 'v1', using: :header, vendor: 'citygram'
    format :json

    rescue_from Sequel::NoMatchingRow do
      Rack::Response.new({error: 'not found'}.to_json, 404)
    end

    desc 'Retrieve a list of publishers'

    params do
      optional :page, type: Integer, default: 1
      optional :per, type: Integer, default: 10, max: 1000
    end

    get '/publishers' do
      Publisher.dataset.paginate(params[:page], params[:per]).order(Sequel.desc(:created_at))
    end
  end
end
