module Citygram::Routes
  class Status < Citygram::App
    # def check
    #   response_hash = Hash.new
    #   #{ :status => "ok", :updated => "", :dependencies => "", :resources => "" }
    #   response_hash[:dependencies] = [ "postgres", "s3" ]
    #   response_hash[:status] = everything_ok? ? "ok" : "NOT OK"
    #   response_hash[:updated] = Time.now.to_i
    #   response_hash[:resources] = {}
    #   render :inline => response_hash.to_json
    # end

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

    get '/status' do
      # status_check = "yes"
      erb :status, :locals => {:status_check => everything_ok?}
    end
  end
end
