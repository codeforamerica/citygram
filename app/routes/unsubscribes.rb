module Citygram::Routes
  class Unsubscribes < Sinatra::Base
    FILTER_WORDS = %w(CANCEL QUIT STOP STOPALL UNSUBSCRIBE)
    FILTER_WORD_REGEXP = Regexp.union(FILTER_WORDS.map{|w| /^#{w}/i })

    username = ENV.fetch('BASIC_AUTH_USERNAME')
    password = ENV.fetch('BASIC_AUTH_PASSWORD')
    use Rack::Auth::Basic, 'Restricted Area' do |u, p|
      u == username && p == password
    end

    post '/unsubscribes' do
      if FILTER_WORD_REGEXP === params['Body']
        phone_number = Phoner::Phone.parse(params['From']).to_s
        Subscription.active.where(phone_number: phone_number).unsubscribe!
      end

      200
    end
  end
end
