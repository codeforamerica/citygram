module Citygram::Routes
  class Digests < Citygram::App
    get '/digests/:subscription_id/events' do
      @subscription = Subscription[params[:subscription_id]]
      @events = Event.from_subscription(@subscription, params)
      erb :digest
    end

    get '/events/email' do
      @subscription = Subscription.where(channel: 'email').last
      @events = Event.from_subscription(@subscription, Event.date_defaults)
      erb :email, layout: false
    end
  end
end
