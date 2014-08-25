# https://github.com/maccman/monocle/blob/56f4639ef652dd5bf168cf5d9d5c7bbc7ab2d79a/lib/sequel/url_validation_helpers.rb
module Sequel::Plugins
  module UrlValidation
    module InstanceMethods
      def validates_url(atts, opts = {})
        validatable_attributes(atts, opts.merge(message: 'is an invalid url')) do |attribute, value, message|
          validation_error_message(message) unless valid_url?(value)
        end
      end

      private

      # a URL may be technically well-formed but may
      # not actually be valid, so this checks for both.
      def valid_url?(url)
        url = URI.parse(url) rescue false
        url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
      end
    end
  end
end
