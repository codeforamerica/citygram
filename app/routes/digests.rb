module Citygram::Routes
  class Digests < Citygram::App
    helpers Citygram::Routes::Helpers

    get '/digests/:subscription_id/reminder' do
      @subscription = Subscription[params[:subscription_id]]
      @events = Event.from_subscription(@subscription, after_date: @subscription.last_notification)
      erb :reminder
    end

    get '/digests/:subscription_id/events' do
      @subscription = Subscription[params[:subscription_id]]
      @events = Event.from_subscription(@subscription, params)
      erb :digest
    end

    get '/unsubscribe/:subscription_id' do
      @subscription = Subscription[params[:subscription_id]]
      @subscription.unsubscribe!
      erb :unsubscribe
    end
  end
end
