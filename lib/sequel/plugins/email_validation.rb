module Sequel::Plugins
  module EmailValidation
    module InstanceMethods
      EMAIL_REGEXP = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/.freeze

      def validates_email(atts, opts = {})
        validatable_attributes(atts, opts.merge(message: 'is an invalid email address')) do |attribute, value, message|
          validation_error_message(message) unless valid_email?(value)
        end
      end

      private

      def valid_email?(value)
        EMAIL_REGEXP === value
      end
    end
  end
end
