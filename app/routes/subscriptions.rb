require 'app/services/channels'

module Citygram::Routes
  class Subscriptions < Grape::API
    version 'v1', using: :header, vendor: 'citygram'
    format :json

    rescue_from Sequel::NoMatchingRow do
      Rack::Response.new({error: 'not found'}.to_json, 404).finish
    end

    rescue_from Sequel::ValidationFailed do |e|
      Rack::Response.new({error: e.message}.to_json, 422).finish
    end

    desc 'Create a new subscription'

    params do
      requires :subscription, type: Hash do
        requires :publisher_id, type: Integer
        requires :channel, type: String, values: Citygram::Services::Channels.available.map(&:to_s)
        requires :geom, type: String
        optional :phone_number, type: String
        optional :email_address, type: String
        optional :webhook_url, type: String
        mutually_exclusive :phone_number, :email_address, :webhook_url
      end
    end

    put '/subscriptions' do
      attr = Hashie.symbolize_keys(params[:subscription].to_h)

      unless (Subscription.duplicate?(attr))
        Subscription.create!(params[:subscription]).tap do |subscription|
          status 201
          Citygram::Workers::SubscriptionConfirmation.perform_async(subscription.id)
        end
      end
    end
  end
end
