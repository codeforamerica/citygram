require 'phone'

module Citygram
  module Models
    module Plugins
      module PhoneValidation

        module InstanceMethods
          def validates_phone(attrs, opts = {})
            validatable_attributes(attrs, opts.merge(message: 'is an invalid phone number')) do |attribute, value, message|
              validation_error_message(message) unless valid_phone?(value)
            end
          end

          private

          def valid_phone?(value)
            Phoner::Phone.parse(value)
          rescue
            false
          end
        end

      end
    end
  end
end
