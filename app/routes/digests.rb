module Citygram::Routes
  class Digests < Citygram::App
    helpers Citygram::Routes::Helpers

    get '/digests/:subscription_id/reminder' do
      @subscription = Subscription[params[:subscription_id]]
      @start_date = 14.days.ago
      @event_count = Event.from_subscription(@subscription, after_date: @start_date).count
      @events = Event.from_subscription(@subscription, after_date: @start_date).limit(100)
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
