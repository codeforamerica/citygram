module Citygram
  module Routes
    class Unsubscribes < Sinatra::Application
      FILTER_WORDS = %w(CANCEL QUIT STOP UNSUBSCRIBE)
      FILTER_WORD_REGEXP = Regexp.union(FILTER_WORDS.map{|w| /^#{w}/i })

      post '/unsubscribes' do
        if FILTER_WORD_REGEXP === params['Body']
          phone_number = Phoner::Phone.parse(params['From']).to_s
          Subscription.where(phone_number: phone_number).update(unsubscribed_at: DateTime.now)
        end

        200
      end
    end
  end
end
