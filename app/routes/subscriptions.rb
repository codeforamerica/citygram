module Georelevent
  module Routes
    class Subscriptions < Grape::API
      version 'v1', using: :header, vendor: 'georelevent'
      format :json

      desc 'Create a new subscription'

      params do
        requires :subscription, type: Hash do
          requires :geom, type: String
        end
      end

      post '/subscriptions' do
        Subscription.create(params[:subscription])
      end
    end
  end
end
