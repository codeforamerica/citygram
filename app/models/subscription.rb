require 'app/services/channels'

module Citygram
  module Models
    class Subscription < Sequel::Model
      many_to_one :publisher

      set_allowed_columns :contact, :geom, :publisher_id, :channel

      plugin :serialization, :geojson, :geom
      plugin Citygram::Models::Plugins::URLValidation
      plugin Citygram::Models::Plugins::EmailValidation
      plugin Citygram::Models::Plugins::GeometryValidation

      def validate
        super
        validates_presence [:geom, :contact, :publisher_id, :channel]
        validates_includes Citygram::Services::Channels.available.map(&:to_s), :channel

        case channel
        when 'webhook'
          validates_url :contact
        when 'email'
          validates_email :contact
        when 'sms'
          # TODO: best way to validate phone numbers
          # validates_phone_number :contact
        end

        validates_geometry :geom
      end
    end
  end
end
