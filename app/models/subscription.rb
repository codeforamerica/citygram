require 'app/services/channels'

module Citygram
  module Models
    class Subscription < Sequel::Model
      many_to_one :publisher

      set_allowed_columns :geom, :publisher_id, :channel,
                          :webhook_url, :phone_number, :email_address

      plugin :serialization, :geojson, :geom
      plugin :serialization, :phone, :phone_number
      plugin Citygram::Models::Plugins::URLValidation
      plugin Citygram::Models::Plugins::EmailValidation
      plugin Citygram::Models::Plugins::GeometryValidation
      plugin Citygram::Models::Plugins::PhoneValidation

      def validate
        super
        validates_presence [:geom, :publisher_id, :channel]
        validates_includes Citygram::Services::Channels.available.map(&:to_s), :channel

        case channel
        when 'webhook'
          validates_url :webhook_url
        when 'email'
          validates_email :email_address
        when 'sms'
          validates_phone :phone_number
        end

        validates_geometry :geom
      end
    end
  end
end
