module Citygram::Routes
  class Digests < Citygram::App
    get '/digests/:subscription_id/events' do
      @subscription = Subscription[params[:subscription_id]]
      @events = Event.from_subscription(@subscription, params)
      erb :digest
    end

    get '/events/email' do
      content_type 'text/html'
      @subscription = Subscription.where(channel: 'email').last
      @events = Event.from_subscription(@subscription, Event.date_defaults)
      template = ERB.new(File.read(File.join(Citygram::App.root, '/app/views/email.erb')))
      template.result(binding)
    end
  end
end
