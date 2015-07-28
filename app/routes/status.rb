module Citygram::Routes
  class Status < Grape::API
    version 'v1', using: :header, vendor: 'citygram'
    format :json

    desc 'Check Status of Application'

    helpers do
      def check
        everything_ok? ? "ok" : "NOT OK"
      end

      def everything_ok?
        # Check that we have some database presence and core data is available
        database_okay? && twilio_response_okay?
      end

      def database_okay?
        Publisher.first.present?
      end

      def twilio_response_okay?
        uri = URI('https://api.twilio.com/2010-04-01')
        res = Net::HTTP.get_response(uri)
        if res.code == "200"
          true
        else
          false
        end
      end
    end

    get '/status' do
      {
        status: check,
        dependencies: [ "postgres", "twilio" ],
        updated: Time.now.to_i
      }
    end
  end
end
