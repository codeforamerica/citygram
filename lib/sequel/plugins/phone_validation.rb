module Sequel::Plugins
  module PhoneValidation
    module InstanceMethods
      def validates_phone(attrs, opts = {})
        validatable_attributes(attrs, opts.merge(message: 'is an invalid phone number')) do |attribute, value, message|
          validation_error_message(message) unless valid_phone?(value)
        end
      end

      private

      def valid_phone?(value)
        phone = Phoner::Phone.parse(value)
        phone.number.length == 7 && phone.area_code.length == 3
      rescue
        false
      end
    end
  end
end
