module Citygram::Routes
  class Digests < Citygram::App
    get '/digests/:subscription_id/events' do
      subscription = Subscription[params[:subscription_id]]
      geom = GeoRuby::GeojsonParser.new.parse(subscription.geom).as_ewkt
      params[:publisher_id] = subscription.publisher_id

      @results = Event.from_geom(geom, params)
      erb :digest
    end
  end
end
